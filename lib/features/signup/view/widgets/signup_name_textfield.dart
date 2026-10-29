part of '../signup_screen.dart';

class _SignupNameTextfield extends StatelessWidget {
  const _SignupNameTextfield();

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
          validator: (fullName) {
            if (fullName?.isEmpty ?? false) {
              return l10n.fullNameRequired;
            }
            return null;
          },
          controller: cubit.fullNameController,
          hinText: l10n.fullName,
          prefixIcon: Icon(Icons.person_outlined, size: 28, color: iconColor),
        ),
        SizedBox(height: 15),
        CustomTextField(
          validator: (userName) {
            if (userName?.isEmpty ?? false) {
              return l10n.usernameRequired;
            }
            return null;
          },
          controller: cubit.userNameController,
          hinText: l10n.username,
          prefixIcon: Icon(Icons.person_outlined, size: 28, color: iconColor),
        ),
      ],
    );
  }
}
