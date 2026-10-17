
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shoply_app/core/service/upload_image_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color primaryColor = Color(0xFF07583F);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  final _picker = ImagePicker();

  File? _selectedImage;
  String _currentImage = '';

  bool _loading = true;
  bool _saving = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = _user;

      if (user == null) {
        throw StateError('Please log in first');
      }

      final doc = await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get();

      final data = doc.data() ?? {};

      if (!mounted) return;

      _nameController.text =
          (data['fullName'] as String?) ??
              user.displayName ??
              '';

      _usernameController.text =
          (data['userName'] as String?) ?? '';

      _addressController.text =
          (data['address'] as String?) ?? '';

      _emailController.text = user.email ?? '';

      _currentImage =
          (data['profileImage'] as String?) ?? '';
    } catch (error) {
      _showMessage('Unable to load account: $error');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image == null || !mounted) return;

      setState(() {
        _selectedImage = File(image.path);
      });
    } catch (error) {
      _showMessage('Unable to select image: $error');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ================= SAVE ACCOUNT DATA =================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_saving) return;

    final user = _user;

    if (user == null) {
      _showMessage('Please log in first');
      return;
    }

    setState(() => _saving = true);

    try {
      String imageUrl = _currentImage;

      // Upload new image using existing Supabase service
      if (_selectedImage != null) {
        final uploadedUrl =
            await UploadImageService.uplaodImage(
          imageFile: _selectedImage!,
        );

        if (uploadedUrl == null ||
            uploadedUrl.isEmpty) {
          throw Exception('Image upload failed');
        }

        imageUrl = uploadedUrl;
      }

      await FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .update({
        'fullName': _nameController.text.trim(),
        'userName': _usernameController.text.trim(),
        'address': _addressController.text.trim(),
        'profileImage': imageUrl,
      });

      if (!mounted) return;

      setState(() {
        _currentImage = imageUrl;
        _selectedImage = null;
      });

      _showMessage('Profile updated successfully!');
    } catch (error) {
      _showMessage('Failed to save profile: $error');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  // ================= CHANGE EMAIL =================

  Future<void> _changeEmail() async {
    final user = _user;
    final newEmail = _emailController.text.trim();

    if (user == null) {
      _showMessage('Please log in first');
      return;
    }

    if (newEmail.isEmpty ||
        !newEmail.contains('@')) {
      _showMessage('Please enter a valid email');
      return;
    }

    if (newEmail == user.email) {
      _showMessage('This is already your email');
      return;
    }

    try {
      await user.verifyBeforeUpdateEmail(newEmail);

      _showMessage(
        'Verification email sent. '
        'Check your new email to confirm the change.',
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'requires-recent-login') {
        _showMessage(
          'Please log out and log in again, '
          'then retry changing your email.',
        );
      } else {
        _showMessage(error.message ?? error.code);
      }
    } catch (error) {
      _showMessage('Unable to change email: $error');
    }
  }

  // ================= RESET PASSWORD =================

  Future<void> _resetPassword() async {
    final email = _user?.email;

    if (email == null || email.isEmpty) {
      _showMessage('No account email available');
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email);

      _showMessage(
        'Password reset email sent to $email',
      );
    } on FirebaseAuthException catch (error) {
      _showMessage(error.message ?? error.code);
    } catch (error) {
      _showMessage('Unable to send reset email: $error');
    }
  }

  // ================= TEXT FIELD =================

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: primaryColor,
          ),
          filled: true,
          fillColor: const Color(0xFFF7F9F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (_currentImage.isNotEmpty) {
      imageProvider = NetworkImage(_currentImage);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight:FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ================= PROFILE IMAGE =================
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor:
                              const Color(0xFFE7F4EE),
                          backgroundImage: imageProvider,
                          child: imageProvider == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: primaryColor,
                                )
                              : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: primaryColor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: _saving
                                  ? null
                                  : _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Edit Account Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _field(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  _field(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.alternate_email,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),

                  _field(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 10),

                  // ================= SAVE =================
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          _saving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                      child: _saving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ================= ACCOUNT SECURITY =================
                  const Text(
                    'Account Security',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _field(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  OutlinedButton.icon(
                    onPressed: _changeEmail,
                    icon: const Icon(
                      Icons.mark_email_read_outlined,
                    ),
                    label: const Text(
                      'Verify New Email Address',
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: _resetPassword,
                    icon: const Icon(
                      Icons.lock_reset,
                    ),
                    label: const Text(
                      'Change Password via Email',
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
