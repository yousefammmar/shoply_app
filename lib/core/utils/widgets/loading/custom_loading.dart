import 'package:flutter/material.dart';
import 'package:shoply_app/l10n/l10n.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static void showDialogLoading({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primary),
              const SizedBox(height: 15),
              Text(
                context.l10n.pleaseWait,
                style: TextStyle(
                  color: primary,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
