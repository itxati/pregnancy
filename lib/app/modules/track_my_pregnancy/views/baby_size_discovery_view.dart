import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../data/models/pregnancy_weeks.dart';

class BabySizeDiscoveryView extends StatefulWidget {
  const BabySizeDiscoveryView({super.key});

  @override
  State<BabySizeDiscoveryView> createState() => _BabySizeDiscoveryViewState();
}

class _BabySizeDiscoveryViewState extends State<BabySizeDiscoveryView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  int selectedWeek = 6;
  final PageController _pageController = PageController(initialPage: 5);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFAFA), // NeoSafeColors.warmWhite
              Color(0xFFF8F2F2), // NeoSafeColors.lightBeige
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          _buildHeader(),
                          _buildWeekSelector(),
                          _buildBabySizeCard(),
                          _buildSizeComparison(),
                          // _buildDevelopmentInfo(),
                          // _buildFunFacts(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: NeoSafeColors.primaryPink),
          onPressed: () => Get.back(),
        ),
      ),
      title: Text(
        'Baby Size Discovery',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: NeoSafeColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeader() {
    final weekData = pregnancyWeeks.firstWhere(
      (data) => data.week == selectedWeek,
      orElse: () => pregnancyWeeks.first,
    );

    final imagePath = 'assets/Safe/week${selectedWeek}.jpg';

    return Container(
      margin: const EdgeInsets.all(20),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Week image as background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: NeoSafeGradients.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Week $selectedWeek',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Dark overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          // Content overlay
          // Positioned.fill(
          //   child: Padding(
          //     padding: const EdgeInsets.all(24),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         if (weekData.emoji != null)
          //           Text(
          //             weekData.emoji!,
          //             style: const TextStyle(fontSize: 48),
          //           ),
          //         const SizedBox(height: 16),
          //         Text(
          //           'Week $selectedWeek',
          //           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w700,
          //               ),
          //           textAlign: TextAlign.center,
          //         ),
          //         const SizedBox(height: 8),
          //         Text(
          //           weekData.comparison?.toUpperCase() ?? 'GROWING BABY',
          //           style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //                 color: Colors.white.withOpacity(0.9),
          //                 fontWeight: FontWeight.w600,
          //                 letterSpacing: 1.2,
          //               ),
          //           textAlign: TextAlign.center,
          //         ),
          //         const SizedBox(height: 8),
          //         Text(
          //           'Tap to discover the size of your baby!',
          //           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //                 color: Colors.white.withOpacity(0.8),
          //               ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Week',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: NeoSafeColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedWeek = index + 1;
                });
              },
              itemCount: 40,
              itemBuilder: (context, index) {
                final week = index + 1;
                final isSelected = week == selectedWeek;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedWeek = week;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? NeoSafeGradients.roseGradient
                          : LinearGradient(
                              colors: [
                                NeoSafeColors.lightBeige,
                                NeoSafeColors.creamWhite,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    NeoSafeColors.roseAccent.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Week',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : NeoSafeColors.secondaryText,
                                  ),
                        ),
                        Text(
                          '$week',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBabySizeCard() {
    final weekData = pregnancyWeeks.firstWhere(
      (data) => data.week == selectedWeek,
      orElse: () => pregnancyWeeks.first,
    );

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: NeoSafeGradients.nurturingGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.nurturingRose.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $selectedWeek',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weekData.comparison?.toUpperCase() ?? 'GROWING BABY',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: NeoSafeColors.roseAccent,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
              if (weekData.emoji != null)
                Text(
                  weekData.emoji!,
                  style: const TextStyle(fontSize: 48),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSizeInfoCard(
                  'Length',
                  weekData.size,
                  Icons.straighten,
                  NeoSafeColors.lavenderPink,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSizeInfoCard(
                  'Weight',
                  weekData.weight.isNotEmpty ? weekData.weight : 'N/A',
                  Icons.monitor_weight,
                  NeoSafeColors.babyPink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSizeInfoCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: NeoSafeColors.secondaryText,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: NeoSafeColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeComparison() {
    final weekData = pregnancyWeeks.firstWhere(
      (data) => data.week == selectedWeek,
      orElse: () => pregnancyWeeks.first,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NeoSafeColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.compare_arrows,
                  color: NeoSafeColors.primaryPink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Size Comparison',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.babyPink.withOpacity(0.3),
                  NeoSafeColors.maternalGlow.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your baby is about the size of:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.secondaryText,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weekData.comparison?.toUpperCase() ?? 'A GROWING BABY',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: NeoSafeColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: NeoSafeColors.primaryPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      weekData.emoji ?? '👶',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopmentInfo() {
    final weekData = pregnancyWeeks.firstWhere(
      (data) => data.week == selectedWeek,
      orElse: () => pregnancyWeeks.first,
    );

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NeoSafeColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology,
                  color: NeoSafeColors.info,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'What\'s Happening',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (weekData.whatsHappening != null) ...[
            Text(
              weekData.whatsHappening!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: NeoSafeColors.primaryText,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 16),
          ],
          if (weekData.body != null) ...[
            Text(
              weekData.body!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.secondaryText,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 16),
          ],
          if (weekData.details != null && weekData.details!.isNotEmpty) ...[
            Text(
              'Key Developments:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...weekData.details!.map((detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: NeoSafeColors.primaryPink,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          detail,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                    height: 1.4,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildFunFacts() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: NeoSafeGradients.glowGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.babyPink.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Fun Fact',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getFunFact(selectedWeek),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  String _getFunFact(int week) {
    final funFacts = {
      1: 'At week 1, your baby is just a tiny cluster of cells, smaller than a grain of salt!',
      2: 'By week 2, your baby\'s heart will start beating - the first sign of life!',
      3: 'At week 3, your baby is about the size of a poppy seed.',
      4: 'Week 4: Your baby\'s neural tube is forming - the foundation of their brain and spine!',
      5: 'At week 5, your baby\'s heart is beating about 100 times per minute.',
      6: 'Week 6: Your baby\'s arms and legs are starting to form as tiny buds.',
      7: 'At week 7, your baby\'s face is beginning to take shape with eyes and nostrils.',
      8: 'Week 8: Your baby is now officially called a fetus instead of an embryo!',
      9: 'At week 9, your baby can make their first movements, though you won\'t feel them yet.',
      10: 'Week 10: All your baby\'s major organs are formed and starting to function!',
      11: 'At week 11, your baby\'s head makes up about half of their body length.',
      12: 'Week 12: Your baby\'s reflexes are developing - they can now move their fingers and toes!',
      13: 'At week 13, your baby\'s vocal cords are forming - they\'re preparing to cry!',
      14: 'Week 14: Your baby can now make facial expressions like frowning and squinting.',
      15: 'At week 15, your baby\'s bones are hardening and becoming stronger.',
      16: 'Week 16: Your baby can now hear your voice and heartbeat!',
      17: 'At week 17, your baby\'s fingerprints are fully formed and unique.',
      18: 'Week 18: Your baby is practicing breathing movements with their developing lungs.',
      19: 'At week 19, your baby\'s skin is covered in a protective coating called vernix.',
      20: 'Week 20: Congratulations! You\'re halfway through your pregnancy journey!',
      21: 'At week 21, your baby can now taste the amniotic fluid through their taste buds.',
      22: 'Week 22: Your baby\'s eyebrows and eyelashes are fully formed.',
      23: 'At week 23, your baby can hear sounds from outside the womb clearly.',
      24: 'Week 24: Your baby\'s face is now fully formed and looks like a newborn!',
      25: 'At week 25, your baby\'s brain is growing rapidly - about 250,000 neurons per minute!',
      26: 'Week 26: Your baby\'s eyes can now open and close, and they can see light.',
      27: 'At week 27, your baby can now dream during REM sleep cycles.',
      28: 'Week 28: Your baby\'s brain is developing rapidly - they\'re getting smarter every day!',
      29: 'At week 29, your baby can now distinguish between light and dark.',
      30: 'Week 30: Your baby\'s brain is growing so fast it\'s creating new neural connections every second!',
      31: 'At week 31, your baby can now process information and form memories.',
      32: 'Week 32: Your baby\'s toenails have grown in completely.',
      33: 'At week 33, your baby\'s immune system is developing to protect them after birth.',
      34: 'Week 34: Your baby\'s lungs are almost fully developed and ready for breathing.',
      35: 'At week 35, your baby\'s brain is about 2/3 of its final size.',
      36: 'Week 36: Your baby is gaining about 1/2 pound per week now!',
      37: 'At week 37, your baby is considered "early term" and could be born safely.',
      38: 'Week 38: Your baby\'s brain is still growing rapidly - about 1/3 of its growth happens in the last few weeks!',
      39: 'At week 39, your baby\'s brain is about 3/4 of its final size.',
      40: 'Week 40: Your baby is fully developed and ready to meet the world!',
    };

    return funFacts[week] ??
        'Every week brings amazing new developments for your growing baby!';
  }
}
