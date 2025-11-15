import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart'; // adjust this path if needed

class GoToHomeIconButton extends StatelessWidget {
  final Color iconColor;
  final Color circleColor;
  final double top;

  const GoToHomeIconButton(
      {Key? key,
      this.iconColor = NeoSafeColors.primaryPink, // default icon color
      this.circleColor = Colors.white, // default background color
      this.top = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        left: 16,
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed('/goal_selection'),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: circleColor,
          child: Icon(
            Icons.home_rounded,
            color: iconColor,
            size: 26,
          ),
        ),
      ),
    );
  }
}
