import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const LoginTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: NeoSafeColors.primaryText,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NeoSafeColors.mediumGray,
                ),
            filled: true,
            fillColor: NeoSafeColors.warmWhite.withOpacity(0.9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: NeoSafeColors.softGray.withOpacity(0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: NeoSafeColors.primaryPink,
                width: 2,
              ),
            ),
            isDense: true,
            // Do not use errorText here to avoid changing the field's appearance
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText!,
              style: TextStyle(color: NeoSafeColors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
