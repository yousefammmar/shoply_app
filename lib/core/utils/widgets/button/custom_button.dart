import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.style,
    this.onPressed,
  });
  final String buttonText;
  final TextStyle? style;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 62,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(18),
          ),
          backgroundColor: cs.primary,
        ),
        child: Text(
          buttonText,
          style:
              style ??
              TextStyle(
                fontSize: 30,
                color: cs.onPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
