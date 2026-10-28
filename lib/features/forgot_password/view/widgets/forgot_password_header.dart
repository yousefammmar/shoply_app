part of '../forgot_password_screen.dart';

class _ForgotPasswordHeader extends StatelessWidget {
  const _ForgotPasswordHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primary.withValues(alpha: 0.15),
          ),
          child: Icon(Icons.lock, size: 70, color: cs.primary),
        ),
        SizedBox(height: 20),
        Text(
          context.l10n.forgotPassword,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 15),
        Text(
          context.l10n.forgotPasswordSubtitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: cs.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
