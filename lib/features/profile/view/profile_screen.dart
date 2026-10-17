import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const green = Color(0xFF07583F);
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please log in first')));
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget reveal(Widget w, int delay) => reduced ? w : w.animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 360.ms)
      .slideY(begin: .07, end: 0, delay: Duration(milliseconds: delay), duration: 420.ms);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Profile'), centerTitle: true,
          backgroundColor: Colors.white, foregroundColor: green),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('User').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Could not load account: ${snapshot.error}'));
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
              radius: 55, backgroundColor: const Color(0xFFE7F4EE),
              backgroundImage: image.isEmpty ? null : NetworkImage(image),
              child: image.isEmpty ? const Icon(Icons.person, size: 60, color: green) : null,
            )), 0),
            const SizedBox(height: 14),
            reveal(Text(name.isEmpty ? 'Shoply User' : name, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), 90),
            const SizedBox(height: 5),
            reveal(Text(username.isEmpty ? '' : '@$username', textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey)), 130),
            const SizedBox(height: 27),
            reveal(_Info(icon: Icons.person_outline, title: 'Full Name', value: name), 160),
            reveal(_Info(icon: Icons.alternate_email, title: 'Username', value: username), 210),
            reveal(_Info(icon: Icons.email_outlined, title: 'Email', value: email), 260),
            reveal(_Info(icon: Icons.location_on_outlined, title: 'Address', value: address), 310),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('User').doc(user.uid).collection('orders').snapshots(),
              builder: (context, orders) => reveal(_Info(
                icon: Icons.inventory_2_outlined,
                title: 'Number of Orders',
                value: orders.hasError ? 'Unavailable' : orders.hasData ? '${orders.data!.docs.length}' : 'Loading...',
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
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFFF7F9F8), borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      Icon(icon, color: const Color(0xFF07583F)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 5),
        Text(value.isEmpty ? 'Not provided' : value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ])),
    ]),
  );
}
