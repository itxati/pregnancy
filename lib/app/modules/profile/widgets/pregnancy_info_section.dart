import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';

class PregnancyInfoSection extends StatelessWidget {
  final ProfileController controller;

  const PregnancyInfoSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Text(
                "Pregnancy",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
              ),
              const SizedBox(height: 12),

              // Pregnancy Info Items
              _buildInfoItem(
                context,
                icon: Icons.calendar_today,
                iconColor: NeoSafeColors.primaryPink,
                title: "Due date:",
                value: controller.dueDate.value,
                onTap: () => _showDatePicker(context),
              ),

              // Simplified: removed Baby's sex, Baby's name, and First Child options

              // Simplify: remove less-used toggles

              // Additional pregnancy information
              _buildInfoItem(
                context,
                icon: Icons.bloodtype,
                iconColor: NeoSafeColors.primaryPink,
                title: "Baby's blood group:",
                value: controller.babyBloodGroup.value,
                onTap: () => _showBloodGroupSelector(context, true),
              ),

              _buildInfoItem(
                context,
                icon: Icons.bloodtype,
                iconColor: NeoSafeColors.roseAccent,
                title: "Mother's blood group:",
                value: controller.motherBloodGroup.value,
                onTap: () => _showBloodGroupSelector(context, false),
              ),

              _buildInfoItem(
                context,
                icon: Icons.family_restroom,
                iconColor: NeoSafeColors.lavenderPink,
                title: "Relation:",
                value: controller.relation.value,
                onTap: () => _showRelationSelector(context),
              ),

              _buildInfoItem(
                context,
                icon: Icons.cake,
                iconColor: NeoSafeColors.coralPink,
                title: "Baby's birth date:",
                value: controller.babyBirthDate.value,
                onTap: () => _showBirthDatePicker(context),
              ),
            ],
          ),
        ));
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: NeoSafeColors.softGray.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: NeoSafeColors.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeoSafeColors.softGray.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: NeoSafeColors.primaryPink,
            activeTrackColor: NeoSafeColors.primaryPink.withOpacity(0.3),
            inactiveThumbColor: NeoSafeColors.secondaryText,
            inactiveTrackColor: NeoSafeColors.softGray,
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 280)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: NeoSafeColors.primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: NeoSafeColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        controller.updateDueDate(
            "${date.day} ${_getMonthName(date.month)} ${date.year}");
      }
    });
  }

  void _showSexSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Baby's Sex",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSelectionOption(context, "Boy", "Boy", fieldType: 'sex'),
              _buildSelectionOption(context, "Girl", "Girl", fieldType: 'sex'),
              _buildSelectionOption(context, "Surprise", "Surprise",
                  fieldType: 'sex'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionOption(BuildContext context, String title, String value,
      {String? fieldType}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        switch (fieldType) {
          case 'sex':
            controller.updateBabySex(value);
            break;
          case 'firstChild':
            controller.updateIsFirstChild(value);
            break;
          case 'babyBloodGroup':
            controller.updateBabyBloodGroup(value);
            break;
          case 'motherBloodGroup':
            controller.updateMotherBloodGroup(value);
            break;
          case 'relation':
            controller.updateRelation(value);
            break;
          default:
            break;
        }
        Navigator.pop(context);
      },
    );
  }

  void _showNameInput(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Baby's Name"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: "Type baby's name...",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                controller.updateBabyName(name);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showFirstChildSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Is this your first child?",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSelectionOption(context, "Yes", "Yes",
                  fieldType: 'firstChild'),
              _buildSelectionOption(context, "No", "No",
                  fieldType: 'firstChild'),
            ],
          ),
        ),
      ),
    );
  }

  void _showBloodGroupSelector(BuildContext context, bool isBaby) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select ${isBaby ? 'Baby' : 'Mother'}'s Blood Group",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSelectionOption(context, "A+", "A+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "A-", "A-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "B+", "B+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "B-", "B-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "O+", "O+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "O-", "O-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "AB+", "AB+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "AB-", "AB-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
            ],
          ),
        ),
      ),
    );
  }

  void _showRelationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Relation",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              // Show the same relations as in the info form
              _buildSelectionOption(context, "Relative", "Relative",
                  fieldType: 'relation'),
              _buildSelectionOption(context, "First Cousin", "First Cousin",
                  fieldType: 'relation'),
              _buildSelectionOption(context, "Second Cousin", "Second Cousin",
                  fieldType: 'relation'),
              _buildSelectionOption(context, "No Relation", "No Relation",
                  fieldType: 'relation'),
            ],
          ),
        ),
      ),
    );
  }

  void _showBirthDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Example first date
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: NeoSafeColors.coralPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: NeoSafeColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        controller.updateBabyBirthDate(
            "${date.day} ${_getMonthName(date.month)} ${date.year}");
      }
    });
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
