import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.titleText,
    this.actions,
    this.actionsPadding,
    this.leading,
    this.title,
  });
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final EdgeInsetsGeometry? actionsPadding;
  final Widget? title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: actionsPadding,
      actions: actions,
      leading: leading,
      title:
          title ??
          Text(
            titleText ?? '',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontStyle: FontStyle.normal,
            ),
          ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
