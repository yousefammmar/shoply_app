import 'package:flutter/material.dart';
import 'package:pro_dialog/pro_dialog.dart';
import 'package:shoply_app/l10n/l10n.dart';

class CustomDialogError extends StatelessWidget {
  const CustomDialogError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static void showProDialogError({
    required BuildContext context,
    required String title,
    required String description,
    required void Function() onPressed,
  }) {
    showProDialog(
      context,
      type: DialogType.error,
      title: title,
      description: description,
      buttons: [
        DialogButton(
          text: context.l10n.gotIt,
          onPressed: onPressed,
          isPrimary: true,
        ),
      ],
    );
  }
}
