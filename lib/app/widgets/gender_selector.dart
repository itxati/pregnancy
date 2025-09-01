// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../services/theme_service.dart';

// class GenderSelector extends StatelessWidget {
//   final String? selectedGender; // "male" or "female"
//   final ValueChanged<String> onChanged;

//   const GenderSelector({
//     Key? key,
//     required this.selectedGender,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _genderContainer(
//           context,
//           gender: "male",
//           icon: Icons.male,
//           label: "male".tr,
//           selected: selectedGender == "male",
//           onTap: () => onChanged("male"),
//         ),
//         const SizedBox(width: 24),
//         _genderContainer(
//           context,
//           gender: "female",
//           icon: Icons.female,
//           label: "female".tr,
//           selected: selectedGender == "female",
//           onTap: () => onChanged("female"),
//         ),
//       ],
//     );
//   }

//   Widget _genderContainer(
//     BuildContext context, {
//     required String gender,
//     required IconData icon,
//     required String label,
//     required bool selected,
//     required VoidCallback onTap,
//   }) {
//     final themeService = Get.find<ThemeService>();
//     final primaryColor = themeService.getPrimaryColor();

//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//         decoration: BoxDecoration(
//           color: selected ? primaryColor.withOpacity(0.1) : Colors.white,
//           border: Border.all(
//             color: selected ? primaryColor : Colors.grey.shade300,
//             width: selected ? 2.5 : 1.0,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: selected
//               ? [
//                   BoxShadow(
//                     color: primaryColor.withOpacity(0.15),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: selected ? primaryColor : Colors.grey, size: 36),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected ? primaryColor : Colors.grey,
//                 fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/theme_service.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender; // "male" or "female"
  final ValueChanged<String> onChanged;

  const GenderSelector({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _genderContainer(
          context,
          gender: "male",
          icon: Icons.male,
          label: "male".tr,
          selected: selectedGender == "male",
          onTap: () => onChanged("male"),
        ),
        const SizedBox(width: 24),
        _genderContainer(
          context,
          gender: "female",
          icon: Icons.female,
          label: "female".tr,
          selected: selectedGender == "female",
          onTap: () => onChanged("female"),
        ),
      ],
    );
  }

  Widget _genderContainer(
    BuildContext context, {
    required String gender,
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    // Use your NeoSafeColors directly instead of theme service
    const primaryPink = Color(0xFFE8A5A5); // NeoSafeColors.primaryPink
    const lightPink = Color(0xFFF2C2C2); // NeoSafeColors.lightPink
    const palePink = Color(0xFFFAE8E8); // NeoSafeColors.palePink
    const creamWhite = Color(0xFFFFFAFA); // NeoSafeColors.creamWhite
    const primaryText = Color(0xFF3D2929); // NeoSafeColors.primaryText
    const mediumGray = Color(0xFF9B9595); // NeoSafeColors.mediumGray
    const softGray = Color(0xFFE8E2E2); // NeoSafeColors.softGray

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: selected ? palePink : creamWhite,
          border: Border.all(
            color: selected ? primaryPink : softGray,
            width: selected ? 2.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primaryPink.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? primaryPink : mediumGray, size: 36),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? primaryText : mediumGray,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
