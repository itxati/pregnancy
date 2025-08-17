import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import 'login_gradient_button.dart';

class InfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? selectedBabyBloodGroup;
  final String? selectedMotherBloodGroup;
  final String? selectedRelation;
  final ValueChanged<String?> onBabyBloodGroupChanged;
  final ValueChanged<String?> onMotherBloodGroupChanged;
  final ValueChanged<String?> onRelationChanged;
  final VoidCallback onContinue;
  final ImageProvider? avatarImage;
  final VoidCallback onAvatarTap;

  const InfoForm({
    super.key,
    required this.formKey,
    required this.selectedBabyBloodGroup,
    required this.selectedMotherBloodGroup,
    required this.selectedRelation,
    required this.onBabyBloodGroupChanged,
    required this.onMotherBloodGroupChanged,
    required this.onRelationChanged,
    required this.onContinue,
    required this.avatarImage,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    final relations = [
      'Relative',
      'First Cousin',
      'Second Cousin',
      'No Relation'
    ];
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: NeoSafeColors.softGray,
                      border: Border.all(
                        color: NeoSafeColors.primaryPink.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: avatarImage != null
                        ? ClipOval(
                            child: Image(
                              image: avatarImage!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: NeoSafeColors.primaryPink.withOpacity(0.6),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: NeoSafeColors.primaryPink.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Personal Info',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: NeoSafeColors.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your details (optional)',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NeoSafeColors.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 22),
          DropdownButtonFormField<String>(
            value: selectedBabyBloodGroup,
            decoration: InputDecoration(
              labelText: "Baby's Blood Group",
              labelStyle: TextStyle(
                color: NeoSafeColors.mediumGray,
                fontWeight: FontWeight.w400,
              ),
              floatingLabelStyle: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: NeoSafeColors.creamWhite.withOpacity(0.9),
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
                borderSide:
                    BorderSide(color: NeoSafeColors.primaryPink, width: 2),
              ),
              isDense: true,
              alignLabelWithHint: false,
            ),
            dropdownColor: NeoSafeColors.creamWhite,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: NeoSafeColors.primaryText,
                ),
            items: bloodGroups
                .map((bg) => DropdownMenuItem(
                      value: bg,
                      child: Text(bg),
                    ))
                .toList(),
            onChanged: onBabyBloodGroupChanged,
            validator: (_) => null, // Optional
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedMotherBloodGroup,
            decoration: InputDecoration(
              labelText: "Mother's Blood Group",
              labelStyle: TextStyle(
                color: NeoSafeColors.mediumGray,
                fontWeight: FontWeight.w400,
              ),
              floatingLabelStyle: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: NeoSafeColors.creamWhite.withOpacity(0.9),
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
                borderSide:
                    BorderSide(color: NeoSafeColors.primaryPink, width: 2),
              ),
              isDense: true,
              alignLabelWithHint: false,
            ),
            dropdownColor: NeoSafeColors.creamWhite,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: NeoSafeColors.primaryText,
                ),
            items: bloodGroups
                .map((bg) => DropdownMenuItem(
                      value: bg,
                      child: Text(bg),
                    ))
                .toList(),
            onChanged: onMotherBloodGroupChanged,
            validator: (_) => null, // Optional
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedRelation,
            decoration: InputDecoration(
              labelText: "Relation",
              labelStyle: TextStyle(
                color: NeoSafeColors.mediumGray,
                fontWeight: FontWeight.w400,
              ),
              floatingLabelStyle: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: NeoSafeColors.creamWhite.withOpacity(0.9),
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
                borderSide:
                    BorderSide(color: NeoSafeColors.primaryPink, width: 2),
              ),
              isDense: true,
              alignLabelWithHint: false,
            ),
            dropdownColor: NeoSafeColors.creamWhite,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: NeoSafeColors.primaryText,
                ),
            items: relations
                .map((rel) => DropdownMenuItem(
                      value: rel,
                      child: Text(rel),
                    ))
                .toList(),
            onChanged: onRelationChanged,
            validator: (_) => null, // Optional
          ),
          const SizedBox(height: 22),
          LoginGradientButton(
            text: 'Continue',
            onTap: onContinue,
          ),
        ],
      ),
    );
  }
}
