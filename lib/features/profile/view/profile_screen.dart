
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF07583F);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in first')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight:FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),
      body: StreamBuilder<
          DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load profile: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.data() ?? {};

          final fullName =
              (data['fullName'] as String?) ?? '';
          final userName =
              (data['userName'] as String?) ?? '';
          final address =
              (data['address'] as String?) ?? '';
          final profileImage =
              (data['profileImage'] as String?) ?? '';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 12),

              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor:
                      const Color(0xFFE7F4EE),
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : null,
                  child: profileImage.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: primaryColor,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                fullName.isNotEmpty
                    ? fullName
                    : user.displayName ?? 'Shoply User',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                userName.isNotEmpty ? '@$userName' : '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 28),

              _ProfileInfoTile(
                icon: Icons.person_outline,
                title: 'Full Name',
                value: fullName,
              ),

              _ProfileInfoTile(
                icon: Icons.alternate_email,
                title: 'Username',
                value: userName,
              ),

              _ProfileInfoTile(
                icon: Icons.email_outlined,
                title: 'Email',
                value: user.email ?? '',
              ),

              _ProfileInfoTile(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: address,
              ),

              // ================= NUMBER OF ORDERS =================
              StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('User')
                    .doc(user.uid)
                    .collection('orders')
                    .snapshots(),
                builder: (context, ordersSnapshot) {
                  final count =
                      ordersSnapshot.data?.docs.length;

                  return _ProfileInfoTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'Number of Orders',
                    value: ordersSnapshot.hasError
                        ? 'Unavailable'
                        : count == null
                            ? 'Loading...'
                            : '$count',
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF07583F),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.isNotEmpty
                      ? value
                      : 'Not provided',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
