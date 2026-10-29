import 'package:flutter/material.dart';

/// Rounded settings row. With [selected] null it shows a chevron (navigation);
/// otherwise it shows a check when selected (choice lists).
class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool? selected;
  final VoidCallback onTap;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reduced = MediaQuery.disableAnimationsOf(context);
    final isSelected = selected ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? cs.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          selected: isSelected,
          contentPadding: const EdgeInsetsDirectional.only(start: 16, end: 12),
          leading: Icon(icon, color: cs.primary),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
          ),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: TextStyle(color: cs.onSurfaceVariant)),
          trailing: selected == null
              ? Icon(Icons.chevron_right, color: cs.onSurfaceVariant)
              : AnimatedSwitcher(
                  duration: reduced
                      ? Duration.zero
                      : const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey(true),
                          color: cs.primary,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          key: const ValueKey(false),
                          color: cs.outlineVariant,
                        ),
                ),
        ),
      ),
    );
  }
}
