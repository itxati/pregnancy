import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   gradient: const RadialGradient(
        //     colors: [
        //       NeoSafeColors.creamWhite,
        //       NeoSafeColors.palePink,
        //     ],
        //     center: Alignment.center,
        //     radius: 0.8,
        //   ),
        //   boxShadow: [
        //     BoxShadow(
        //       color: NeoSafeColors.primaryPink.withOpacity(0.2),
        //       blurRadius: 12,
        //       offset: const Offset(0, 4),
        //     ),
        //   ],
        // ),
        // child: Padding(
        //   padding: const EdgeInsets.all(4.0),
        //   child: ClipOval(
        child: Image.asset(
          'assets/logos/logo.png',
          fit: BoxFit.fitHeight,
        ),
        //   ),
        // ),
      ),
    );
  }
}
