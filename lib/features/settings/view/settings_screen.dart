import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoply_app/core/service/upload_image_service.dart';
import 'package:shoply_app/features/app/view_model/app_settings_cubit.dart';
import 'package:shoply_app/features/settings/view/appearance_screen.dart';
import 'package:shoply_app/features/settings/view/language_screen.dart';
import 'package:shoply_app/features/settings/view/widgets/change_password_dialog.dart';
import 'package:shoply_app/features/settings/view/widgets/settings_option_tile.dart';
import 'package:shoply_app/features/cart/view/widgets/checkout_success_dialog.dart';
import 'package:shoply_app/l10n/l10n.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      builder: (context) => CheckoutSuccessDialog(
        title: context.l10n.passwordUpdatedTitle,
        message: context.l10n.passwordUpdatedMessage,
        buttonText: context.l10n.done,
      ),
    );
  }

  void _openPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  void initState() { super.initState(); _load(); }
  @override
  void dispose() { _name.dispose(); _username.dispose(); _address.dispose(); _email.dispose(); super.dispose(); }

  // Messages are built lazily so the context is only read while mounted.
  void _notify(String Function(AppLocalizations l10n) message, {bool error = false}) {
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message(context.l10n)), backgroundColor: error ? cs.error : cs.primary,
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
    } catch (e) { _notify((l10n) => l10n.couldNotLoadProfile(e), error: true); }
    finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _pick() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 1200);
      if (picked != null && mounted) setState(() => _newImage = File(picked.path));
    } catch (e) { _notify((l10n) => l10n.imageSelectionFailed(e), error: true); }
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final user = _user;
    if (user == null) return _notify((l10n) => l10n.pleaseLogIn, error: true);
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
      _notify((l10n) => l10n.accountUpdated);
    } catch (e) { _notify((l10n) => l10n.saveFailed(e), error: true); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  Future<void> _changeEmail() async {
    final user = _user;
    final requested = _email.text.trim();
    if (user == null) return _notify((l10n) => l10n.pleaseLogIn, error: true);
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(requested)) {
      return _notify((l10n) => l10n.emailInvalid, error: true);
    }
    if (requested == user.email) return _notify((l10n) => l10n.currentEmailAlready);
    try {
      await user.verifyBeforeUpdateEmail(requested);
      _notify((l10n) => l10n.verificationEmailSent);
      // We intentionally do NOT overwrite Firestore email before verification.
    } on FirebaseAuthException catch (e) {
      _notify((l10n) => e.code == 'requires-recent-login' ? l10n.signInAgainAndRetry : (e.message ?? e.code), error: true);
    } catch (e) { _notify((l10n) => l10n.emailChangeFailed(e), error: true); }
  }

  Future<void> _resetPassword() async {
    final email = _user?.email;
    if (email == null || email.isEmpty) return _notify((l10n) => l10n.noEmailOnAccount, error: true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _notify((l10n) => l10n.resetEmailSentTo(email));
    } catch (e) { _notify((l10n) => l10n.couldNotSendResetLink(e), error: true); }
  }

  Widget _field(String label, IconData icon, TextEditingController controller, {bool required = false}) {
    final cs = Theme.of(context).colorScheme;
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: TextFormField(
      controller: controller,
      validator: required ? (v) => v == null || v.trim().isEmpty ? context.l10n.requiredField : null : null,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: cs.primary), filled: true,
        fillColor: cs.surfaceContainerLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: cs.primary, width: 2)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final themeMode = context.watch<AppSettingsCubit>().state.themeMode;
    final reduced = MediaQuery.disableAnimationsOf(context);
    Widget reveal(Widget child, int delay) => reduced ? child : child.animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 350.ms)
      .slideY(begin: .07, end: 0, delay: Duration(milliseconds: delay), duration: 420.ms);
    final ImageProvider? image = _newImage != null ? FileImage(_newImage!)
        : _image.isNotEmpty ? NetworkImage(_image) : null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true,
        foregroundColor: cs.primary),
      body: _loading ? const Center(child: CircularProgressIndicator())
          : Form(key: _form, child: ListView(padding: const EdgeInsets.all(20), children: [
            reveal(Center(child: Stack(children: [
              AnimatedSwitcher(
                duration: reduced ? Duration.zero : const Duration(milliseconds: 280),
                child: CircleAvatar(key: ValueKey(_newImage?.path ?? _image),
                  radius: 54, backgroundColor: cs.primaryContainer,
                  backgroundImage: image,
                  child: image == null ? Icon(Icons.person, size: 55, color: cs.primary) : null),
              ),
              PositionedDirectional(bottom: 0, end: 0, child: CircleAvatar(
                backgroundColor: cs.primary, radius: 19,
                child: IconButton(onPressed: _saving ? null : _pick,
                  icon: Icon(Icons.camera_alt, color: cs.onPrimary, size: 18)),
              )),
            ])), 0),
            const SizedBox(height: 17),
            reveal(Text(l10n.editAccountInformation, textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), 65),
            const SizedBox(height: 25),
            reveal(_field(l10n.fullName, Icons.person_outline, _name, required: true), 100),
            reveal(_field(l10n.username, Icons.alternate_email, _username, required: true), 140),
            reveal(_field(l10n.address, Icons.location_on_outlined, _address), 180),
            const SizedBox(height: 7),
            SizedBox(height: 51, child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(backgroundColor: cs.primary, foregroundColor: cs.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: _saving ? SizedBox(height: 23, width: 23,
                child: CircularProgressIndicator(color: cs.onPrimary, strokeWidth: 2))
                : Text(l10n.saveChanges, style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
            const SizedBox(height: 29),
            Text(l10n.preferences, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SettingsOptionTile(
              icon: Icons.language_rounded,
              title: l10n.language,
              subtitle: LanguageScreen.currentLanguageName(context),
              onTap: () => _openPage(const LanguageScreen()),
            ),
            SettingsOptionTile(
              icon: Icons.palette_outlined,
              title: l10n.appearance,
              subtitle: themeModeLabel(l10n, themeMode),
              onTap: () => _openPage(const AppearanceScreen()),
            ),
            const SizedBox(height: 17),
            Text(l10n.accountSecurity, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _field(l10n.emailAddress, Icons.email_outlined, _email),

            const SizedBox(height: 11),
            OutlinedButton.icon(
                onPressed: _changePasswordDirectly,
                icon: Icon(
                  Icons.lock_reset_rounded,
                  color: cs.primary,
                ),
                label: Text(l10n.changePassword),
              ),
          ])),
    );
  }
}
