part of '../signup_screen.dart';

class _SignupBottom extends StatelessWidget {
  const _SignupBottom();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    return Column(
      children: [
        CustomButton(
          buttonText: context.l10n.signUp,
          onPressed: () {
            cubit.signup();
          },
        ),
        SizedBox(height: 30),
        CustomTextButtonWrap(
          text: context.l10n.alreadyHaveAccount,
          textClick: ' ${context.l10n.login}',
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppPages.loginScreen,
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}
