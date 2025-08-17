import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';

class TimelineMarker extends StatelessWidget {
  final Color color;
  final IconData icon;

  const TimelineMarker({
    Key? key,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: NeoSafeColors.primaryPink,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: NeoSafeColors.primaryPink,
        size: 12,
      ),
    );
  }
} 