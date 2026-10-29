import 'package:flutter/material.dart';

class CustomTextButtonWrap extends StatelessWidget {
  const CustomTextButtonWrap({
    super.key,
    required this.text,
    required this.textClick,
    this.onTap,
  });
  final String text;
  final String textClick;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: cs.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            textClick,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
      ],
    );
  }
}
