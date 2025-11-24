// // import 'package:flutter/material.dart';

// // class MiscarriageAwarenessCard extends StatelessWidget {
// //   const MiscarriageAwarenessCard({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(vertical: 12),
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(22),
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFFEFD9D7), Color(0xFFF6ECEB)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.pink.withOpacity(0.09),
// //             blurRadius: 12,
// //             offset: Offset(0, 6),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: const [
// //               Icon(Icons.notifications_rounded, color: Color(0xFFD16B6B), size: 32),
// //               SizedBox(width: 12),
// //               Expanded(
// //                 child: Text(
// //                   'Miscarriage Awareness and Early Pregnancy Loss',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 18,
// //                     color: Color(0xFF8D3131),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           _sectionTitle('What is a miscarriage?'),
// //           const SizedBox(height: 4),
// //           const Text(
// //             'A miscarriage is a spontaneous loss of a pregnancy before 20 weeks gestation. (In some countries, this is defined as before 24 weeks.) Miscarriage is more common than many realize and can happen for many reasons, most of which are outside anyone’s control.',
// //             style: TextStyle(fontSize: 15, color: Color(0xFF423636)),
// //           ),
// //           const SizedBox(height: 12),
// //           _sectionTitle('Common signs'),
// //           const SizedBox(height: 4),
// //           _bulletList([
// //             'Vaginal bleeding (light spotting or heavy bleeding)',
// //             'Abdominal cramping or pain',
// //             'Passing tissue or clots from the vagina',
// //             'Sudden loss of pregnancy symptoms (such as nausea or breast tenderness)',
// //           ]),
// //           const SizedBox(height: 12),
// //           _sectionTitle('What should I do if I suspect a miscarriage?'),
// //           const SizedBox(height: 4),
// //           _bulletList([
// //             'Seek immediate medical care if you experience severe bleeding, dizziness, or shoulder pain.',
// //             'Contact your healthcare provider if you are worried about any symptoms.',
// //             'Remember: You are not alone, and healthcare professionals are here to help and support you.',
// //           ]),
// //           const SizedBox(height: 12),
// //           _sectionTitle('Emotional support'),
// //           const SizedBox(height: 4),
// //           const Text(
// //             'Experiencing a miscarriage can be very emotional, and every reaction is valid. Acknowledge your feelings. Talk to friends, family, or a counselor, and consider support organizations or online communities.',
// //             style: TextStyle(fontSize: 15, color: Color(0xFF423636)),
// //           ),
// //           const SizedBox(height: 12),
// //           _sectionTitle('Prevention and risk factors'),
// //           const SizedBox(height: 4),
// //           const Text(
// //             'Most miscarriages cannot be prevented and are not caused by anything you did or didn’t do. Risk factors can include age, a history of miscarriage, certain medical conditions, and lifestyle factors. Clear, non-judgmental information helps support emotional well-being.',
// //             style: TextStyle(fontSize: 15, color: Color(0xFF423636)),
// //           ),
// //           const SizedBox(height: 14),
// //           const Text(
// //             'Remember: Miscarriage is common. Be gentle with yourself. If you need support or more information, please reach out to your healthcare provider or support organizations.',
// //             style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8D3131), fontSize: 15),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   static Widget _sectionTitle(String title) => Text(
// //       title,
// //       style: const TextStyle(
// //         fontWeight: FontWeight.w600,
// //         fontSize: 16.5,
// //         color: Color(0xFFD16B6B),
// //       ),
// //     );

// //   static Widget _bulletList(List<String> items) => Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: items
// //             .map((e) => Padding(
// //                   padding: const EdgeInsets.only(left: 2, bottom: 3),
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text('• ', style: TextStyle(fontSize: 17, color: Color(0xFFD16B6B))),
// //                       Expanded(child: Text(e, style: const TextStyle(fontSize: 15, color: Color(0xFF423636)))),
// //                     ],
// //                   ),
// //                 ))
// //             .toList(),
// //       );
// // }

// import 'package:flutter/material.dart';

// class MiscarriageAwarenessCard extends StatefulWidget {
//   const MiscarriageAwarenessCard({Key? key}) : super(key: key);

//   @override
//   State<MiscarriageAwarenessCard> createState() =>
//       _MiscarriageAwarenessCardState();
// }

// class _MiscarriageAwarenessCardState extends State<MiscarriageAwarenessCard>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleExpanded() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFFF0F0), Color(0xFFFFE5E5), Color(0xFFFFF8F8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFE8A5A5).withOpacity(0.2),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//             spreadRadius: -2,
//           ),
//           BoxShadow(
//             color: const Color(0xFFFFB3BA).withOpacity(0.1),
//             blurRadius: 40,
//             offset: const Offset(0, 16),
//             spreadRadius: -8,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: _toggleExpanded,
//           borderRadius: BorderRadius.circular(24),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Section
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFFE8A5A5), Color(0xFFD4A5A5)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFFE8A5A5).withOpacity(0.3),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.favorite_rounded,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     const Expanded(
//                       child: Text(
//                         'Miscarriage Awareness',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Color(0xFF8D3131),
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                     ),
//                     RotationTransition(
//                       turns: _rotationAnimation,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE8A5A5).withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.keyboard_arrow_down_rounded,
//                           color: Color(0xFFD16B6B),
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // Main Points (Always Visible)
//                 _buildMainPoint(
//                   Icons.info_outline_rounded,
//                   'Spontaneous pregnancy loss before 20 weeks',
//                 ),
//                 const SizedBox(height: 12),
//                 _buildMainPoint(
//                   Icons.warning_amber_rounded,
//                   'Watch for bleeding, cramping, or tissue passing',
//                 ),
//                 const SizedBox(height: 12),
//                 _buildMainPoint(
//                   Icons.local_hospital_rounded,
//                   'Seek medical care if symptoms occur',
//                 ),

//                 // Expandable Details
//                 AnimatedCrossFade(
//                   firstChild: const SizedBox.shrink(),
//                   secondChild: _buildExpandedContent(),
//                   crossFadeState: _isExpanded
//                       ? CrossFadeState.showSecond
//                       : CrossFadeState.showFirst,
//                   duration: const Duration(milliseconds: 300),
//                   sizeCurve: Curves.easeInOut,
//                 ),

//                 // Tap to Expand Hint
//                 if (!_isExpanded)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Center(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE8A5A5).withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Tap to learn more',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Color(0xFFD16B6B),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             SizedBox(width: 4),
//                             Icon(
//                               Icons.touch_app_rounded,
//                               size: 16,
//                               color: Color(0xFFD16B6B),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainPoint(IconData icon, String text) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFB3BA).withOpacity(0.2),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             icon,
//             color: const Color(0xFFD16B6B),
//             size: 20,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 15,
//               color: Color(0xFF423636),
//               fontWeight: FontWeight.w500,
//               height: 1.3,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildExpandedContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 24),

//         // Divider
//         Container(
//           height: 1,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.transparent,
//                 const Color(0xFFE8A5A5).withOpacity(0.3),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//         ),

//         const SizedBox(height: 24),

//         _sectionTitle('What is a miscarriage?'),
//         const SizedBox(height: 12),
//         _descriptionText(
//           'A miscarriage is a spontaneous loss of a pregnancy before 20 weeks gestation. (In some countries, this is defined as before 24 weeks.) Miscarriage is more common than many realize and can happen for many reasons, most of which are outside anyone\'s control.',
//         ),

//         const SizedBox(height: 20),
//         _sectionTitle('Common Signs'),
//         const SizedBox(height: 12),
//         _bulletList([
//           'Vaginal bleeding (light spotting or heavy bleeding)',
//           'Abdominal cramping or pain',
//           'Passing tissue or clots from the vagina',
//           'Sudden loss of pregnancy symptoms',
//         ]),

//         const SizedBox(height: 20),
//         _sectionTitle('What Should I Do?'),
//         const SizedBox(height: 12),
//         _bulletList([
//           'Seek immediate medical care for severe bleeding, dizziness, or shoulder pain',
//           'Contact your healthcare provider if worried about symptoms',
//           'Remember: You are not alone - healthcare professionals are here to help',
//         ]),

//         const SizedBox(height: 20),
//         _sectionTitle('Emotional Support'),
//         const SizedBox(height: 12),
//         _descriptionText(
//           'Experiencing a miscarriage can be very emotional, and every reaction is valid. Acknowledge your feelings. Talk to friends, family, or a counselor, and consider support organizations or online communities.',
//         ),

//         const SizedBox(height: 20),
//         _sectionTitle('Prevention & Risk Factors'),
//         const SizedBox(height: 12),
//         _descriptionText(
//           'Most miscarriages cannot be prevented and are not caused by anything you did or didn\'t do. Risk factors can include age, a history of miscarriage, certain medical conditions, and lifestyle factors.',
//         ),

//         const SizedBox(height: 24),

//         // Final Note
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xFFE8A5A5).withOpacity(0.15),
//                 const Color(0xFFFFB3BA).withOpacity(0.15),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: const Color(0xFFE8A5A5).withOpacity(0.3),
//               width: 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.health_and_safety_rounded,
//                   color: Color(0xFFD16B6B),
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Text(
//                   'Be gentle with yourself. Reach out to your healthcare provider or support organizations for help.',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF8D3131),
//                     fontSize: 14,
//                     height: 1.4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return Row(
//       children: [
//         Container(
//           width: 4,
//           height: 20,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFFE8A5A5), Color(0xFFD4A5A5)],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//             color: Color(0xFFD16B6B),
//             letterSpacing: -0.3,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _descriptionText(String text) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 14.5,
//           color: Color(0xFF423636),
//           height: 1.5,
//         ),
//       ),
//     );
//   }

//   Widget _bulletList(List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: items
//           .map((item) => Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(top: 6),
//                       width: 6,
//                       height: 6,
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Color(0xFFE8A5A5), Color(0xFFFFB3BA)],
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         item,
//                         style: const TextStyle(
//                           fontSize: 14.5,
//                           color: Color(0xFF423636),
//                           height: 1.5,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ))
//           .toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class MiscarriageAwarenessCard extends StatefulWidget {
  const MiscarriageAwarenessCard({Key? key}) : super(key: key);

  @override
  State<MiscarriageAwarenessCard> createState() =>
      _MiscarriageAwarenessCardState();
}

class _MiscarriageAwarenessCardState extends State<MiscarriageAwarenessCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
         gradient: LinearGradient(
          colors: [
            NeoSafeColors.palePink.withOpacity(0.9),
            NeoSafeColors.babyPink.withOpacity(0.8),
            NeoSafeColors.lightPink.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: NeoSafeColors.primaryPink.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8A5A5), Color(0xFFD4A5A5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE8A5A5).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'miscarriage_awareness'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: NeoSafeColors.primaryText,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8A5A5).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFD16B6B),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.info_outline_rounded,
                  'miscarriage_main_point_1'.tr,
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.warning_amber_rounded,
                  'miscarriage_main_point_2'.tr,
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.local_hospital_rounded,
                  'miscarriage_main_point_3'.tr,
                ),

                // Expandable Details
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedContent(),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  sizeCurve: Curves.easeInOut,
                ),

                // Tap to Expand Hint
                if (!_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8A5A5).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'tap_to_learn_more'.tr,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFD16B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFFD16B6B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainPoint(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB3BA).withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFD16B6B),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF423636),
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Divider
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFFE8A5A5).withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        _sectionTitle('what_is_miscarriage'.tr),
        const SizedBox(height: 12),
        _descriptionText(
          'miscarriage_description'.tr,
        ),

        const SizedBox(height: 20),
        _sectionTitle('common_signs'.tr),
        const SizedBox(height: 12),
        _bulletList([
          'sign_vaginal_bleeding'.tr,
          'sign_abdominal_cramping'.tr,
          'sign_passing_tissue'.tr,
          'sign_loss_of_symptoms'.tr,
        ]),

        const SizedBox(height: 20),
        _sectionTitle('what_should_i_do'.tr),
        const SizedBox(height: 12),
        _bulletList([
          'action_seek_immediate_care'.tr,
          'action_contact_provider'.tr,
          'action_not_alone'.tr,
        ]),

        const SizedBox(height: 20),
        _sectionTitle('emotional_support'.tr),
        const SizedBox(height: 12),
        _descriptionText(
          'emotional_support_description'.tr,
        ),

        const SizedBox(height: 20),
        _sectionTitle('prevention_risk_factors'.tr),
        const SizedBox(height: 12),
        _descriptionText(
          'prevention_description'.tr,
        ),

        const SizedBox(height: 24),

        // Final Note
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE8A5A5).withOpacity(0.15),
                const Color(0xFFFFB3BA).withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE8A5A5).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: Color(0xFFD16B6B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'final_note_be_gentle'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8D3131),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8A5A5), Color(0xFFD4A5A5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Color(0xFFD16B6B),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _descriptionText(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.5,
          color: Color(0xFF423636),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE8A5A5), Color(0xFFFFB3BA)],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Color(0xFF423636),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
