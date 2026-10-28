import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/helper/error_handle_helper.dart';
import 'package:shoply_app/core/regex/app_regex.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/utils/widgets/app_bar/custom_app_bar.dart';
import 'package:shoply_app/core/utils/widgets/button/custom_button.dart';
import 'package:shoply_app/core/utils/widgets/dialog/custom_dialog_error.dart';
import 'package:shoply_app/core/utils/widgets/dialog/custom_success_dialog.dart';
import 'package:shoply_app/core/utils/widgets/loading/custom_loading.dart';
import 'package:shoply_app/core/utils/widgets/text_button/custom_text_button.dart';
import 'package:shoply_app/core/utils/widgets/textfield/custom_text_field.dart';
import 'package:shoply_app/features/forgot_password/view_model/cubit.dart';
import 'package:shoply_app/features/forgot_password/view_model/state.dart';
import 'package:shoply_app/l10n/l10n.dart';
part 'widgets/forgot_password_header.dart';
part 'widgets/forgot_password_bottom.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPassswordCubit(),
      child: Scaffold(
        appBar: CustomAppBar(titleText: ''),
        body: BlocListener<ForgotPassswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordLoadingState) {
              CustomLoading.showDialogLoading(context: context);
            } else if (state is ForgotPasswordErrorState) {
              Navigator.pop(context);
              CustomDialogError.showProDialogError(
                context: context,
                title: context.l10n.forgotPasswordError,
                description: ErrorHandleHelper.getCustomErrorMessage(
                  context.l10n,
                  state.errorMessage,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            } else if (state is ForgotPasswordSuccessState) {
              Navigator.pop(context);
              CustomSuccessDialog.showProSuccessDialog(
                context: context,
                title: context.l10n.resetLinkSentTitle,
                description: context.l10n.resetLinkSentMessage,
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
              final cubit = context.read<ForgotPassswordCubit>();
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            _ForgotPasswordHeader(),
                            SizedBox(height: 40),
                            _ForgotPasswordBottom(),
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
