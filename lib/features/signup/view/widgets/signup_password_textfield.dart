part of '../signup_screen.dart';

class _SignupPasswordTextfield extends StatelessWidget {
  const _SignupPasswordTextfield();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    final l10n = context.l10n;
    final iconColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.75);

    return Column(
      children: [
        CustomTextField(
          validator: (password) {
            if (password?.isEmpty ?? false) {
              return l10n.passwordRequired;
            } else if (password!.length < 6) {
              return l10n.passwordTooShort;
            } else if (AppRegex.passwordRegex.hasMatch(password) == false) {
              return l10n.passwordPattern;
            }
            return null;
          },
          obscureText: true,
          controller: cubit.passwordController,
          hinText: l10n.password,
          prefixIcon: Icon(Icons.lock_outline, size: 28, color: iconColor),
        ),
        SizedBox(height: 15),
        CustomTextField(
          validator: (confirmPassword) {
            if (confirmPassword?.isEmpty ?? false) {
              return l10n.confirmPasswordRequired;
            } else if (confirmPassword != cubit.passwordController.text) {
              return l10n.passwordsDoNotMatch;
            }
            return null;
          },
          obscureText: true,
          controller: cubit.confirmPasswordController,
          hinText: l10n.confirmPassword,
          prefixIcon: Icon(Icons.lock_outline, size: 28, color: iconColor),
        ),
      ],
    );
  }
}
