import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoply_app/core/service/upload_image_service.dart';
import 'package:shoply_app/features/settings/view/widgets/change_password_dialog.dart';
import 'package:shoply_app/features/cart/view/widgets/checkout_success_dialog.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const green = Color(0xFF07583F);
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  File? _newImage;
  String _image = '';
  bool _loading = true;
  bool _saving = false;
  User? get _user => FirebaseAuth.instance.currentUser;
  
  Future<void> _changePasswordDirectly() async {
    // Open password change form.
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ChangePasswordDialog(),
    );

    if (!mounted || changed != true) return;

    // Show animated success message only after
    // Firebase Auth confirms the password update.
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CheckoutSuccessDialog(
        title: 'Password Updated!',
        message:
            'Your password has been changed successfully.\n\n'
            'Your account is now secured with your new password.',
        buttonText: 'Done',
      ),
    );
  }

  @override
  void initState() { super.initState(); _load(); }
  @override
  void dispose() { _name.dispose(); _username.dispose(); _address.dispose(); _email.dispose(); super.dispose(); }

  void _notify(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message), backgroundColor: error ? Colors.red : green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _load() async {
    try {
      final user = _user;
      if (user == null) throw StateError('Please log in');
      await user.reload();
      final d = (await FirebaseFirestore.instance.collection('User').doc(user.uid).get()).data() ?? {};
      if (!mounted) return;
      _name.text = (d['fullName'] as String?) ?? user.displayName ?? '';
      _username.text = (d['userName'] as String?) ?? '';
      _address.text = (d['address'] as String?) ?? '';
      _email.text = FirebaseAuth.instance.currentUser?.email ?? '';
      _image = (d['profileImage'] as String?) ?? '';
    } catch (e) { _notify('Could not load profile: $e', error: true); }
    finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _pick() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1200);
      if (picked != null && mounted) setState(() => _newImage = File(picked.path));
    } catch (e) { _notify('Image selection failed: $e', error: true); }
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final user = _user;
    if (user == null) return _notify('Please log in', error: true);
    setState(() => _saving = true);
    try {
      var url = _image;
      if (_newImage != null) {
        final uploaded = await UploadImageService.uplaodImage(imageFile: _newImage!);
        if (uploaded == null || uploaded.isEmpty) throw StateError('Image upload failed');
        url = uploaded;
      }
      await FirebaseFirestore.instance.collection('User').doc(user.uid).update({
        'fullName': _name.text.trim(),
        'userName': _username.text.trim(),
        'address': _address.text.trim(),
        'profileImage': url,
      });
      if (!mounted) return;
      setState(() { _image = url; _newImage = null; });
      _notify('Account updated successfully!');
    } catch (e) { _notify('Save failed: $e', error: true); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  Future<void> _changeEmail() async {
    final user = _user;
    final requested = _email.text.trim();
    if (user == null) return _notify('Please log in', error: true);
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(requested)) {
      return _notify('Enter a valid email', error: true);
    }
    if (requested == user.email) return _notify('This is your current email');
    try {
      await user.verifyBeforeUpdateEmail(requested);
      _notify('Verification sent. Check the new email, then sign in again.');
      // We intentionally do NOT overwrite Firestore email before verification.
    } on FirebaseAuthException catch (e) {
      _notify(e.code == 'requires-recent-login' ? 'Sign in again and retry.' : (e.message ?? e.code), error: true);
    } catch (e) { _notify('Email change failed: $e', error: true); }
  }

  Future<void> _resetPassword() async {
    final email = _user?.email;
    if (email == null || email.isEmpty) return _notify('No email on this account', error: true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _notify('Password reset email sent to $email');
    } catch (e) { _notify('Could not send reset link: $e', error: true); }
  }

  Widget _field(String label, IconData icon, TextEditingController controller, {bool required = false}) {
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: TextFormField(
      controller: controller,
      validator: required ? (v) => v == null || v.trim().isEmpty ? 'Required' : null : null,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: green), filled: true,
        fillColor: const Color(0xFFF7F9F8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: green, width: 2)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget reveal(Widget child, int delay) => reduced ? child : child.animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 350.ms)
      .slideY(begin: .07, end: 0, delay: Duration(milliseconds: delay), duration: 420.ms);
    final ImageProvider? image = _newImage != null ? FileImage(_newImage!)
        : _image.isNotEmpty ? NetworkImage(_image) : null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Settings'), centerTitle: true,
        backgroundColor: Colors.white, foregroundColor: green),
      body: _loading ? const Center(child: CircularProgressIndicator())
          : Form(key: _form, child: ListView(padding: const EdgeInsets.all(20), children: [
            reveal(Center(child: Stack(children: [
              AnimatedSwitcher(
                duration: reduced ? Duration.zero : const Duration(milliseconds: 280),
                child: CircleAvatar(key: ValueKey(_newImage?.path ?? _image),
                  radius: 54, backgroundColor: const Color(0xFFE7F4EE),
                  backgroundImage: image,
                  child: image == null ? const Icon(Icons.person, size: 55, color: green) : null),
              ),
              Positioned(bottom: 0, right: 0, child: CircleAvatar(
                backgroundColor: green, radius: 19,
                child: IconButton(onPressed: _saving ? null : _pick,
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18)),
              )),
            ])), 0),
            const SizedBox(height: 17),
            reveal(const Text('Edit Account Information', textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), 65),
            const SizedBox(height: 25),
            reveal(_field('Full Name', Icons.person_outline, _name, required: true), 100),
            reveal(_field('Username', Icons.alternate_email, _username, required: true), 140),
            reveal(_field('Address', Icons.location_on_outlined, _address), 180),
            const SizedBox(height: 7),
            SizedBox(height: 51, child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: _saving ? const SizedBox(height: 23, width: 23,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            const SizedBox(height: 29),
            const Text('Account Security', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _field('Email Address', Icons.email_outlined, _email),
            
            const SizedBox(height: 11),
            OutlinedButton.icon(
                onPressed: _changePasswordDirectly,
                icon: const Icon(
                  Icons.lock_reset_rounded,
                  color: Color(0xFF07583F),
                ),
                label: const Text('Change Password'),
              ),
          ])),
    );
  }
}
