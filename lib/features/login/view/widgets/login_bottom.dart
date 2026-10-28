part of '../login_screen.dart';

class _LoginBottom extends StatelessWidget {
  const _LoginBottom();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Column(
      children: [
        CustomButton(
          buttonText: context.l10n.login,
          onPressed: () {
            cubit.login();
          },
        ),
        SizedBox(height: 50),
        CustomTextButtonWrap(
          text: context.l10n.noAccount,
          textClick: ' ${context.l10n.signUp}',
          onTap: () {
            Navigator.pushNamed(context, AppPages.signupScreen);
          },
        ),
      ],
    );
  }
}
