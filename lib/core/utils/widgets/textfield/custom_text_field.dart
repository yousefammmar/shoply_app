import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    required this.hinText,
    this.prefixIcon,
    this.obscureText,
  });
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hinText;
  final Widget? prefixIcon;
  final bool? obscureText;

  @override
  State<CustomTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<CustomTextField> {
  bool? isHide;

  @override
  void initState() {
    isHide = widget.obscureText;
    super.initState();
  }

  void changeIsHide() {
    isHide = !(isHide ?? false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      obscureText: isHide ?? false,
      controller: widget.controller,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: cs.onSurface,
      ),
      textInputAction: TextInputAction.next,
      validator: widget.validator,
      cursorColor: cs.onSurfaceVariant,
      decoration: InputDecoration(
        helperText: '',
        helperStyle: TextStyle(fontSize: 12),
        hintText: widget.hinText,
        hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 17),
        suffixIcon: widget.obscureText == true
            ? GestureDetector(
                onTap: () {
                  changeIsHide();
                },
                child: isHide ?? false
                    ? Icon(
                        Icons.visibility_off_outlined,
                        size: 28,
                        color: cs.onSurface.withValues(alpha: 0.75),
                      )
                    : Icon(
                        Icons.visibility_outlined,
                        size: 28,
                        color: cs.onSurface.withValues(alpha: 0.75),
                      ),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
        prefixIcon: widget.prefixIcon,
        fillColor: cs.onSurface.withValues(alpha: 0.06),
        filled: true,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.error, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
