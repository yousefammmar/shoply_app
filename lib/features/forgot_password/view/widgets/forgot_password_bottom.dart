part of '../forgot_password_screen.dart';

class _ForgotPasswordBottom extends StatelessWidget {
  const _ForgotPasswordBottom();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPassswordCubit>();
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        CustomTextField(
          validator: (email) {
            if (email?.isEmpty ?? false) {
              return l10n.emailRequired;
            } else if (AppRegex.emailRegex.hasMatch(email ?? '') == false) {
              return l10n.emailInvalid;
            }
            return null;
          },
          controller: cubit.emailController,
          hinText: l10n.email,
          prefixIcon: Icon(
            Icons.email_outlined,
            size: 28,
            color: cs.onSurface.withValues(alpha: 0.75),
          ),
        ),
        SizedBox(height: 35),
        CustomButton(
          buttonText: l10n.sendResetLink,
          onPressed: () {
            cubit.forgotPassword();
          },
        ),
        SizedBox(height: 30),
        CustomTextButton(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppPages.loginScreen,
              (route) => false,
            );
          },
          textButton: l10n.backToLogin,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
