import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/neo_safe_theme.dart';

class LanguageSwitcher extends StatelessWidget {
  final Color? backgroundColor;
  final Color? selectedTextColor;
  const LanguageSwitcher(
      {super.key, this.backgroundColor, this.selectedTextColor});

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale ?? const Locale('en', 'US');
    final box = GetStorage();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LanguageButton(
          label: 'English',
          isSelected: locale.languageCode == 'en',
          onTap: () {
            print('Switching to English locale');
            Get.updateLocale(const Locale('en', 'US'));
            box.write('locale', 'en');
            print('Current locale after switch: ${Get.locale?.languageCode}');
          },
          backgroundColor: backgroundColor,
          selectedTextColor: selectedTextColor,
        ),
        const SizedBox(width: 8),
        _LanguageButton(
          label: 'اردو',
          isSelected: locale.languageCode == 'ur',
          onTap: () {
            print('Switching to Urdu locale');
            Get.updateLocale(const Locale('ur', 'PK'));
            box.write('locale', 'ur');
            print('Current locale after switch: ${Get.locale?.languageCode}');
          },
          backgroundColor: backgroundColor,
          selectedTextColor: selectedTextColor,
        ),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? selectedTextColor;
  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    this.selectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // High contrast background - white with slight tint or semi-transparent black
          color: isSelected
              ? (backgroundColor ?? Colors.white.withOpacity(0.95))
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          // Simple, thin border for minimal look
          border: Border.all(
            color: isSelected
                ? NeoSafeColors.primaryPink
                : Colors.black.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
          // Minimal shadow only for selected state
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                // High contrast text colors
                color: isSelected
                    ? (selectedTextColor ?? NeoSafeColors.primaryPink)
                    : Colors.black.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
        ),
      ),
    );
  }
}
