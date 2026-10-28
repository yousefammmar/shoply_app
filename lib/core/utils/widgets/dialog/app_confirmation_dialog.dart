
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shoply_app/l10n/l10n.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  // Null values fall back to the localized Confirm / Cancel.
  final String? confirmText;
  final String? cancelText;
  final IconData icon;
  final bool isDangerous;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.icon = Icons.help_outline_rounded,
    this.isDangerous = false,
  });

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    IconData icon = Icons.help_outline_rounded,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        isDangerous: isDangerous,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context);

    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final actionColor = isDangerous ? cs.error : cs.primary;
    final onActionColor = isDangerous ? cs.onError : cs.onPrimary;

    Widget content = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor:
                  actionColor.withValues(alpha: 0.10),
              child: Icon(
                icon,
                color: actionColor,
                size: 38,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: cs.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                    ),
                    child: Text(cancelText ?? l10n.cancel),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionColor,
                      foregroundColor: onActionColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                    ),
                    child: Text(confirmText ?? l10n.confirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (!reduceMotion) {
      content = content
          .animate()
          .fadeIn(duration: 220.ms)
          .scale(
            begin: const Offset(0.88, 0.88),
            end: const Offset(1, 1),
            duration: 350.ms,
            curve: Curves.easeOutBack,
          );
    }

    return content;
  }
}
