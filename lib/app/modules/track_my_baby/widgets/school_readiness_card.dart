import 'package:flutter/material.dart';

class SchoolReadinessCard extends StatefulWidget {
  const SchoolReadinessCard({Key? key}) : super(key: key);

  @override
  State<SchoolReadinessCard> createState() => _SchoolReadinessCardState();
}

class _SchoolReadinessCardState extends State<SchoolReadinessCard>
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
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFF0F8FF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.06),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -8,
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
                          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'School Readiness',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF0D47A1),
                          letterSpacing: -0.5,
        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF1976D2),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Main Points (Always Visible)
                _buildMainPoint(
                  Icons.psychology_rounded,
                  'More than letters/numbers - holistic development',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.people_rounded,
                  'Social-emotional, cognitive, language skills',
                ),
                const SizedBox(height: 12),
                _buildMainPoint(
                  Icons.trending_up_rounded,
                  'Age-appropriate activities & milestones',
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
                if (!_isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3).withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tap to learn more',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0D47A1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app_rounded,
                              size: 16,
                              color: Color(0xFF1976D2),
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
            color: const Color(0xFF64B5F6).withOpacity(0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF0D47A1),
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
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                const Color(0xFF2196F3).withOpacity(0.33),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('What is School Readiness?'),
        const SizedBox(height: 12),
        _descriptionText(
          'School readiness is more than knowing letters/numbers. It\'s a combination of skills, knowledge, attitudes and behaviours that enable a child to begin school and thrive.',
        ),
        const SizedBox(height: 20),
        _sectionTitle('Key Domains'),
        const SizedBox(height: 12),
        _bulletList([
          'Social-emotional development: self-control, forming relationships, recognising feelings, cooperating with others',
          'Cognitive / general knowledge: problem-solving, curiosity, early math, understanding cause & effect',
          'Language & literacy: vocabulary, storytelling, letter recognition, asking/answering questions',
          'Physical & motor development: fine motor skills (holding a pencil), gross motor (running, jumping), stamina to sit and focus',
          'Approaches to learning / executive function / self-regulation: ability to focus, shift attention, follow directions, impulse control',
        ]),
        const SizedBox(height: 20),
        _sectionTitle('Age-wise Progression'),
        const SizedBox(height: 12),
        _subsectionTitle('Birth to ~3 years:'),
        const SizedBox(height: 8),
        _bulletList([
          'Encourage lots of talking, reading, singing. Respond to baby\'s cues (turn-taking)',
          'Play: simple cause-and-effect toys, sensorimotor exploration, safe environment',
          'Social: snuggling, interacting, imitating, simple turn-taking',
          'Self-help: allow safe exploration, picking up items, simple decisions (with supervision)',
        ]),
        const SizedBox(height: 12),
        _subsectionTitle('3–5 years (pre-school stage):'),
        const SizedBox(height: 8),
        _bulletList([
          'Fine-motor: drawing, simple crafts, using scissors (with help)',
          'Language & literacy: tell stories together, ask "what happens next?", introduce letters/numbers through play',
          'Social-emotional: cooperative play, sharing, recognising others\' feelings, taking turns',
          'Cognitive: sorting games, puzzles, counting objects, simple board games',
          'Routine & self-help skills: dressing (with help), going to toilet independently, cleaning up toys, following simple two-step instructions',
          'Transition to a group setting: Encourage play groups or preschool to get used to routines, group interaction',
        ]),
        const SizedBox(height: 12),
        _subsectionTitle('5–8 years (early school age):'),
        const SizedBox(height: 8),
        _bulletList([
          'Reading readiness: Recognising letters, attempting words, reading for fun',
          'Numeracy: Counting, basic addition/subtraction, understanding shapes, patterns',
          'Attention span: Ability to sit for a short story or task, follow multi-step instructions',
          'Self-management: Packing school bag, being responsible for small tasks, following classroom rules',
          'Social skills: Making and keeping friends, resolving small conflicts, cooperating in teams',
          'Health & physical: Good sleep, regular meals, outdoor play, and independence in bathroom/hygiene',
        ]),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF64B5F6).withOpacity(0.14),
                const Color(0xFF2196F3).withOpacity(0.13),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2196F3).withOpacity(0.25),
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
                  Icons.lightbulb_rounded,
                  color: Color(0xFF1976D2),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Research shows self-regulation is strongly tied to school readiness. Support your child\'s development through play, routines, and age-appropriate activities.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D47A1),
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
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
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
            color: Color(0xFF1976D2),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _subsectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }

  Widget _descriptionText(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14.5,
          color: Color(0xFF0D47A1),
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
                          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
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
                          color: Color(0xFF0D47A1),
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

