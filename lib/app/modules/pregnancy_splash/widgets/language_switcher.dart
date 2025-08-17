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
            Get.updateLocale(const Locale('en', 'US'));
            box.write('locale', 'en');
          },
          backgroundColor: backgroundColor,
          selectedTextColor: selectedTextColor,
        ),
        const SizedBox(width: 12),
        _LanguageButton(
          label: 'اردو',
          isSelected: locale.languageCode == 'ur',
          onTap: () {
            Get.updateLocale(const Locale('ur', 'PK'));
            box.write('locale', 'ur');
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (backgroundColor ?? Colors.white)
              : NeoSafeColors.softGray.withOpacity(0.35),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: NeoSafeColors.primaryPink,
            width: isSelected ? 2.5 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: NeoSafeColors.primaryPink.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? (selectedTextColor ?? NeoSafeColors.primaryPink)
                    : NeoSafeColors.primaryPink,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
