import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shoply_app/l10n/l10n.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Scaffold(body: Center(child: Text(l10n.pleaseLogIn)));
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget reveal(Widget w, int delay) => reduced ? w : w.animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 360.ms)
      .slideY(begin: .07, end: 0, delay: Duration(milliseconds: delay), duration: 420.ms);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myProfile), centerTitle: true,
          foregroundColor: cs.primary),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('User').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l10n.couldNotLoadAccount(snapshot.error!)));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final d = snapshot.data!.data() ?? {};
          final name = (d['fullName'] as String?) ?? user.displayName ?? '';
          final username = (d['userName'] as String?) ?? '';
          final address = (d['address'] as String?) ?? '';
          final image = (d['profileImage'] as String?) ?? '';
          final email = user.email ?? (d['email'] as String?) ?? '';
          return ListView(padding: const EdgeInsets.all(20), children: [
            const SizedBox(height: 8),
            reveal(Center(child: CircleAvatar(
              radius: 55, backgroundColor: cs.primaryContainer,
              backgroundImage: image.isEmpty ? null : NetworkImage(image),
              child: image.isEmpty ? Icon(Icons.person, size: 60, color: cs.primary) : null,
            )), 0),
            const SizedBox(height: 14),
            reveal(Text(name.isEmpty ? l10n.shoplyUser : name, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), 90),
            const SizedBox(height: 5),
            reveal(Text(username.isEmpty ? '' : '@$username', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: cs.onSurfaceVariant)), 130),
            const SizedBox(height: 27),
            reveal(_Info(icon: Icons.person_outline, title: l10n.fullName, value: name), 160),
            reveal(_Info(icon: Icons.alternate_email, title: l10n.username, value: username), 210),
            reveal(_Info(icon: Icons.email_outlined, title: l10n.email, value: email), 260),
            reveal(_Info(icon: Icons.location_on_outlined, title: l10n.address, value: address), 310),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('User').doc(user.uid).collection('orders').snapshots(),
              builder: (context, orders) => reveal(_Info(
                icon: Icons.inventory_2_outlined,
                title: l10n.numberOfOrders,
                value: orders.hasError ? l10n.unavailable : orders.hasData ? '${orders.data!.docs.length}' : l10n.loading,
              ), 360),
            ),
          ]);
        },
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _Info({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      Icon(icon, color: cs.primary),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
        const SizedBox(height: 5),
        Text(value.isEmpty ? context.l10n.notProvided : value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ])),
    ]),
  );
  }
}
