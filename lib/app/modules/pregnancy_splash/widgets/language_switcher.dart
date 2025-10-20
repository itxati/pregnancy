// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../../utils/neo_safe_theme.dart';

// class LanguageSwitcher extends StatelessWidget {
//   final Color? backgroundColor;
//   final Color? selectedTextColor;
//   const LanguageSwitcher(
//       {super.key, this.backgroundColor, this.selectedTextColor});

//   @override
//   Widget build(BuildContext context) {
//     final locale = Get.locale ?? const Locale('en', 'US');
//     final box = GetStorage();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _LanguageButton(
//           label: 'English',
//           isSelected: locale.languageCode == 'en',
//           onTap: () {
//             print('Switching to English locale');
//             Get.updateLocale(const Locale('en', 'US'));
//             box.write('locale', 'en');
//             print('Current locale after switch: ${Get.locale?.languageCode}');
//           },
//           backgroundColor: backgroundColor,
//           selectedTextColor: selectedTextColor,
//         ),
//         const SizedBox(width: 8),
//         _LanguageButton(
//           label: 'اردو',
//           isSelected: locale.languageCode == 'ur',
//           onTap: () {
//             print('Switching to Urdu locale');
//             Get.updateLocale(const Locale('ur', 'PK'));
//             box.write('locale', 'ur');
//             print('Current locale after switch: ${Get.locale?.languageCode}');
//           },
//           backgroundColor: backgroundColor,
//           selectedTextColor: selectedTextColor,
//         ),
//       ],
//     );
//   }
// }

// class _LanguageButton extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final Color? backgroundColor;
//   final Color? selectedTextColor;
//   const _LanguageButton({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//     this.backgroundColor,
//     this.selectedTextColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           // High contrast background - white with slight tint or semi-transparent black
//           color: isSelected
//               ? (backgroundColor ?? Colors.white.withOpacity(0.95))
//               : Colors.black.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(20),
//           // Simple, thin border for minimal look
//           border: Border.all(
//             color: isSelected
//                 ? NeoSafeColors.primaryPink
//                 : Colors.black.withOpacity(0.2),
//             width: isSelected ? 1.5 : 1,
//           ),
//           // Minimal shadow only for selected state
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Text(
//           label,
//           style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                 // High contrast text colors
//                 color: isSelected
//                     ? (selectedTextColor ?? NeoSafeColors.primaryPink)
//                     : Colors.black.withOpacity(0.7),
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 fontSize: 13,
//               ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/neo_safe_theme.dart';

class LanguageSwitcher extends StatefulWidget {
  final Color? backgroundColor;
  final Color? selectedTextColor;

  const LanguageSwitcher({
    super.key,
    this.backgroundColor,
    this.selectedTextColor,
  });

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  final box = GetStorage();
  late String _selectedLang;

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'locale': const Locale('en', 'US')},
    {'code': 'ur', 'name': 'اردو', 'locale': const Locale('ur', 'PK')},
    // {'code': 'skr', 'name': 'سرائیکی', 'locale': const Locale('skr', 'PK')},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLang = box.read('locale') ?? Get.locale?.languageCode ?? 'en';
  }

  void _changeLanguage(String code) {
    final selected = _languages.firstWhere((lang) => lang['code'] == code);
    Locale locale = selected['locale'];

    // Update locale (fallback for Saraiki handled by GetX)
    Get.updateLocale(locale);

    // Save preference
    box.write('locale', code);
    setState(() => _selectedLang = code);

    debugPrint('Switched to: ${selected['name']} (${selected['code']})');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeoSafeColors.primaryPink.withOpacity(0.8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLang,
          icon: const Icon(Icons.language, color: Colors.pinkAccent),
          borderRadius: BorderRadius.circular(12),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.selectedTextColor ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
          dropdownColor: Colors.white,
          items: _languages
              .map(
                (lang) => DropdownMenuItem<String>(
                  value: lang['code'],
                  child: Text(lang['name']),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) _changeLanguage(value);
          },
        ),
      ),
    );
  }
}
