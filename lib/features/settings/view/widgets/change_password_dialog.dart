
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoply_app/l10n/l10n.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState
    extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _loading = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String _errorMessage(FirebaseAuthException error) {
    final l10n = context.l10n;
    switch (error.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.currentPasswordIncorrect;

      case 'weak-password':
        return l10n.chooseStrongerPassword;

      case 'requires-recent-login':
        return l10n.signInAgainAndRetry;

      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;

      case 'network-request-failed':
        return l10n.authErrorNetwork;

      default:
        return l10n.unableToUpdatePassword;
    }
  }

  Future<void> _updatePassword() async {
    if (_loading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage(context.l10n.pleaseLogIn, isError: true);
      return;
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      _showMessage(
        context.l10n.noEmailOnAccount,
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // 1. Verify the current password.
      final credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPassword.text,
      );

      await user.reauthenticateWithCredential(
        credential,
      );

      // 2. Update password using Firebase Auth.
      await user.updatePassword(
        _newPassword.text,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      _showMessage(
        _errorMessage(error),
        isError: true,
      );
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        context.l10n.authErrorUnexpected,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;
    final cs = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? cs.error : cs.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: !visible,
        autocorrect: false,
        enableSuggestions: false,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: cs.primary,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
          filled: true,
          fillColor: cs.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: cs.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 26,
          bottom: 22 +
              MediaQuery.viewInsetsOf(context).bottom * 0.15,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: cs.primaryContainer,
                child: Icon(
                  Icons.lock_reset_rounded,
                  size: 37,
                  color: cs.primary,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                l10n.changePassword,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                l10n.updatePasswordSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              _passwordField(
                label: l10n.currentPassword,
                controller: _currentPassword,
                visible: _showCurrent,
                onToggle: () {
                  setState(() {
                    _showCurrent = !_showCurrent;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterCurrentPassword;
                  }
                  return null;
                },
              ),

              _passwordField(
                label: l10n.newPassword,
                controller: _newPassword,
                visible: _showNew,
                onToggle: () {
                  setState(() {
                    _showNew = !_showNew;
                  });
                },
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return l10n.useAtLeast8Characters;
                  }
                  if (value == _currentPassword.text) {
                    return l10n.chooseDifferentPassword;
                  }
                  return null;
                },
              ),

              _passwordField(
                label: l10n.confirmNewPassword,
                controller: _confirmPassword,
                visible: _showConfirm,
                onToggle: () {
                  setState(() {
                    _showConfirm = !_showConfirm;
                  });
                },
                validator: (value) {
                  if (value != _newPassword.text) {
                    return l10n.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _loading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                      ),
                      child: _loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cs.onPrimary,
                              ),
                            )
                          : Text(l10n.update),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
