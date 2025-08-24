import 'package:flutter/material.dart';

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
          label: "Male",
          selected: selectedGender == "male",
          onTap: () => onChanged("male"),
        ),
        const SizedBox(width: 24),
        _genderContainer(
          context,
          gender: "female",
          icon: Icons.female,
          label: "Female",
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: selected ? Colors.pink.shade50 : Colors.white,
          border: Border.all(
            color: selected ? Colors.pink : Colors.grey.shade300,
            width: selected ? 2.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? Colors.pink : Colors.grey, size: 36),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.pink : Colors.grey,
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
