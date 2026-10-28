import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/helper/error_handle_helper.dart';
import 'package:shoply_app/core/regex/app_regex.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/utils/images/app_images.dart';
import 'package:shoply_app/core/utils/widgets/app_bar/custom_app_bar.dart';
import 'package:shoply_app/core/utils/widgets/button/custom_button.dart';
import 'package:shoply_app/core/utils/widgets/dialog/custom_dialog_error.dart';
import 'package:shoply_app/core/utils/widgets/dialog/custom_success_dialog.dart';
import 'package:shoply_app/core/utils/widgets/loading/custom_loading.dart';
import 'package:shoply_app/core/utils/widgets/text_button/custom_text_button_wrap.dart';
import 'package:shoply_app/core/utils/widgets/textfield/custom_text_field.dart';
import 'package:shoply_app/features/signup/view_model/cubit.dart';
import 'package:shoply_app/features/signup/view_model/state.dart';
import 'package:shoply_app/l10n/l10n.dart';
part 'widgets/singup_header.dart';
part 'widgets/signup_name_textfield.dart';
part 'widgets/signup_email_address_textfield.dart';
part 'widgets/signup_password_textfield.dart';
part 'widgets/signup_bottom.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Scaffold(
        appBar: CustomAppBar(titleText: context.l10n.createAccount),
        body: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupLoadingState) {
              CustomLoading.showDialogLoading(context: context);
            } else if (state is SignupErrorState) {
              Navigator.pop(context);
              CustomDialogError.showProDialogError(
                context: context,
                title: context.l10n.signUpError,
                description: ErrorHandleHelper.getCustomErrorMessage(
                  context.l10n,
                  state.errorMessage,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            } else if (state is SignupSuccessState) {
              Navigator.pop(context);
              CustomSuccessDialog.showProSuccessDialog(
                context: context,
                title: context.l10n.signUpSuccessTitle,
                description: context.l10n.signUpSuccessMessage,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppPages.loginScreen,
                    (route) => false,
                  );
                },
              );
            }
          },
          child: Builder(
            builder: (context) {
              final cubit = context.read<SignupCubit>();
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            _SingupHeader(),
                            SizedBox(height: 20),
                            _SignupNameTextfield(),
                            SizedBox(height: 15),
                            _SignupEmailAddressTextfield(),
                            SizedBox(height: 15),
                            _SignupPasswordTextfield(),
                            SizedBox(height: 20),
                            _SignupBottom(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
