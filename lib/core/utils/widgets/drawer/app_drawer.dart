
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback? onProfile;
  final VoidCallback? onOrders;
  final VoidCallback? onFavorites;
  final VoidCallback? onSettings;
  final VoidCallback? onSupport;

  const AppDrawer({
    super.key,
    required this.onLogout,
    this.onProfile,
    this.onOrders,
    this.onFavorites,
    this.onSettings,
    this.onSupport,
  });

  static const Color primaryColor = Color(0xFF07583F);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final items = [
      _DrawerItem('My Profile', Icons.person_outline, onProfile),
      _DrawerItem('My Orders', Icons.inventory_2_outlined, onOrders),
      _DrawerItem('Favorites', Icons.favorite_border, onFavorites),
      _DrawerItem('Settings', Icons.settings_outlined, onSettings),
      _DrawerItem('Help & Support', Icons.help_outline, onSupport),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ================= USER HEADER =================

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: user == null
                  ? null
                  : FirebaseFirestore.instance
                      .collection('User')
                      .doc(user.uid)
                      .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data();

                final fullName =
                    (data?['fullName'] as String?)?.trim() ?? '';

                final userName =
                    (data?['userName'] as String?)?.trim() ?? '';

                final email =
                    (data?['email'] as String?)?.trim() ??
                    user?.email ??
                    '';

                final profileImage =
                    (data?['profileImage'] as String?)?.trim() ?? '';

                final displayName = fullName.isNotEmpty
                    ? fullName
                    : (user?.displayName?.isNotEmpty ?? false)
                        ? user!.displayName!
                        : 'Shoply User';

                final imageUri = Uri.tryParse(profileImage);

                final hasValidImage =
                    imageUri != null &&
                    imageUri.hasAuthority &&
                    (imageUri.scheme == 'https' ||
                        imageUri.scheme == 'http');

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: primaryColor,
                  child: Row(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: hasValidImage
                              ? Image.network(
                                  profileImage,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return const Icon(
                                      Icons.person,
                                      color: primaryColor,
                                      size: 32,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.person,
                                  color: primaryColor,
                                  size: 32,
                                ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // User Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              userName.isNotEmpty
                                  ? '@$userName'
                                  : email,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.15, end: 0);
              },
            ),

            const SizedBox(height: 16),

            // ================= MENU ITEMS =================

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 4,
                    ),
                    leading: Icon(
                      item.icon,
                      color: primaryColor,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: item.onTap == null
                        ? null
                        : () {
                            Navigator.pop(context);
                            item.onTap!();
                          },
                  )
                      .animate()
                      .fadeIn(
                        delay: Duration(
                          milliseconds: index * 70,
                        ),
                        duration: 350.ms,
                      )
                      .slideX(
                        begin: -0.12,
                        end: 0,
                        duration: 350.ms,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
            ),

            // ================= LOGOUT =================

            const Divider(),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 12,
              ),
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ================= DRAWER ITEM MODEL =================

class _DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _DrawerItem(
    this.title,
    this.icon,
    this.onTap,
  );
}
