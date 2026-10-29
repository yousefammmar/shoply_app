part of '../signup_screen.dart';

class _SignupEmailAddressTextfield extends StatelessWidget {
  const _SignupEmailAddressTextfield();

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
          prefixIcon: Icon(Icons.email_outlined, size: 28, color: iconColor),
        ),
        SizedBox(height: 15),
        CustomTextField(
          validator: (address) {
            if (address?.isEmpty ?? false) {
              return l10n.addressRequired;
            }
            return null;
          },
          controller: cubit.addressController,
          hinText: l10n.address,
          prefixIcon: Icon(
            Icons.location_on_outlined,
            size: 28,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
