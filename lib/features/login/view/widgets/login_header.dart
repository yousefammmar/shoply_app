part of '../login_screen.dart';

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Image(
          image: NetworkImage(AppImages.splash),
          height: 200,
          width: 240,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 10),
        Text(
          context.l10n.welcomeBack,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
        Text(
          context.l10n.signInToContinue,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
