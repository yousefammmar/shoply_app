part of '../login_screen.dart';

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final iconColor = cs.onSurface.withValues(alpha: 0.75);

    return Column(
      children: [
        CustomTextField(
          validator: (email) {
            if (email?.isEmpty ?? false) {
              return l10n.emailRequired;
            }
            return null;
          },
          controller: cubit.emailController,
          hinText: l10n.email,
          prefixIcon: Icon(Icons.email_outlined, size: 28, color: iconColor),
        ),
        SizedBox(height: 30),
        CustomTextField(
          validator: (password) {
            if (password?.isEmpty ?? false) {
              return l10n.passwordRequired;
            }
            return null;
          },
          obscureText: true,
          controller: cubit.passwordController,
          hinText: l10n.password,
          prefixIcon: Icon(Icons.lock_outline, size: 28, color: iconColor),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppPages.forgotPasswordScreen);
          },
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              l10n.forgotPassword,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
