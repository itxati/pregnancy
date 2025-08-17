import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';

class LoginGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  const LoginGradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: NeoSafeGradients.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          NeoSafeColors.creamWhite),
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    text,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: NeoSafeColors.creamWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 1.1,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
