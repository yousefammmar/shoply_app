
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() =>
      _ChangePasswordDialogState();
}

class _ChangePasswordDialogState
    extends State<ChangePasswordDialog> {
  static const Color green = Color(0xFF07583F);

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
    switch (error.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Your current password is incorrect.';

      case 'weak-password':
        return 'Please choose a stronger password.';

      case 'requires-recent-login':
        return 'Please sign in again and retry.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return error.message ?? 'Unable to update password.';
    }
  }

  Future<void> _updatePassword() async {
    if (_loading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('Please log in first.', isError: true);
      return;
    }

    final email = user.email;

    if (email == null || email.isEmpty) {
      _showMessage(
        'This account does not have an email address.',
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
      _showMessage(
        _errorMessage(error),
        isError: true,
      );
    } catch (_) {
      _showMessage(
        'Something went wrong. Please try again.',
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : green,
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
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: green,
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
          fillColor: const Color(0xFFF7F9F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: green,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
              const CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFFE7F4EE),
                child: Icon(
                  Icons.lock_reset_rounded,
                  size: 37,
                  color: green,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Update your password securely.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              _passwordField(
                label: 'Current Password',
                controller: _currentPassword,
                visible: _showCurrent,
                onToggle: () {
                  setState(() {
                    _showCurrent = !_showCurrent;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your current password';
                  }
                  return null;
                },
              ),

              _passwordField(
                label: 'New Password',
                controller: _newPassword,
                visible: _showNew,
                onToggle: () {
                  setState(() {
                    _showNew = !_showNew;
                  });
                },
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Use at least 8 characters';
                  }
                  if (value == _currentPassword.text) {
                    return 'Choose a different password';
                  }
                  return null;
                },
              ),

              _passwordField(
                label: 'Confirm New Password',
                controller: _confirmPassword,
                visible: _showConfirm,
                onToggle: () {
                  setState(() {
                    _showConfirm = !_showConfirm;
                  });
                },
                validator: (value) {
                  if (value != _newPassword.text) {
                    return 'Passwords do not match';
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
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _loading ? null : _updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Update'),
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
