import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/models/pregnancy_weeks.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class BabyDevelopmentPage extends StatefulWidget {
  final int pregnancyDays;

  const BabyDevelopmentPage({Key? key, required this.pregnancyDays})
      : super(key: key);

  @override
  State<BabyDevelopmentPage> createState() => _BabyDevelopmentPageState();
}

class _BabyDevelopmentPageState extends State<BabyDevelopmentPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  int currentWeekIndex = 0;
  int currentDetailIndex = 0;
  bool showDetails = false;

  // Auto-play related variables
  bool isAutoPlaying = true;
  bool hasAutoPlayCompleted = false;
  bool canManualSwipe = false;

  @override
  void initState() {
    super.initState();
    int calculatedWeek = (widget.pregnancyDays / 7).ceil();
    if (calculatedWeek < 1) calculatedWeek = 1;
    if (calculatedWeek >= pregnancyWeeks.length)
      calculatedWeek = pregnancyWeeks.length - 1;

    currentWeekIndex = calculatedWeek;
    _pageController = PageController(initialPage: currentWeekIndex);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Start auto-play after initial animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    // Stop auto-play when disposing
    _stopAutoPlay();
    _pageController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startAutoPlay() async {
    if (!isAutoPlaying || hasAutoPlayCompleted) return;

    // Wait for initial page to settle
    await Future.delayed(const Duration(milliseconds: 1000));

    while (isAutoPlaying && !hasAutoPlayCompleted && mounted) {
      if (currentWeekIndex < pregnancyWeeks.length - 1) {
        // Move to next page with smooth animation
        await _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );

        // Wait before moving to next page
        await Future.delayed(const Duration(milliseconds: 1200));
      } else {
        // Reached the last page, stop auto-play
        _stopAutoPlay();
        break;
      }
    }
  }

  void _stopAutoPlay() {
    setState(() {
      isAutoPlaying = false;
      hasAutoPlayCompleted = true;
      canManualSwipe = true;
    });
  }

  void _showNextDetail() {
    final details = pregnancyWeeks[currentWeekIndex].details ?? [];
    setState(() {
      if (details.isNotEmpty) {
        currentDetailIndex = (currentDetailIndex + 1) % details.length;
        showDetails = true;
      }
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              // Disable manual swiping during auto-play
              physics: canManualSwipe
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentWeekIndex = index;
                  currentDetailIndex = 0;
                  showDetails = false;
                });
                _animationController.reset();
                _animationController.forward();
              },
              itemCount: pregnancyWeeks.length,
              itemBuilder: (context, index) {
                return _buildFullScreenWeekPage(pregnancyWeeks[index], theme);
              },
            ),
            _buildHeader(theme),
            // Auto-play indicator removed
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final weekData = pregnancyWeeks[currentWeekIndex];
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: NeoSafeGradients.primaryGradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 24),
                  onPressed: () {
                    // Stop auto-play when user presses back/close
                    _stopAutoPlay();
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${weekData.week}",
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'weeks_label'.tr,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (weekData.size.trim().isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.straighten,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          weekData.size ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 16),
                if (weekData.length.trim().isNotEmpty)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        weekData.length.tr ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                if (weekData.weight.trim().isNotEmpty)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "${'weight'.tr}: ${weekData.weight ?? ''}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenWeekPage(weekData, ThemeData theme) {
    return GestureDetector(
      // Stop auto-play when user taps anywhere on the screen
      onTap: () {
        if (isAutoPlaying) {
          _stopAutoPlay();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full screen background image (extends behind app bar)
          Image.asset(
            'assets/Safe/week${weekData.week}.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: NeoSafeColors.creamWhite,
            ),
          ),

          // Dark overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),

          // Info button (bottom left)
          Positioned(
            bottom: 30,
            left: 30,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: NeoSafeColors.primaryPink.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: NeoSafeColors.primaryPink.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Stop auto-play when info button is pressed
                        if (isAutoPlaying) {
                          _stopAutoPlay();
                        }
                        setState(() {
                          showDetails = !showDetails;
                          if (showDetails) {
                            currentDetailIndex = 0;
                          }
                        });
                        _animationController.reset();
                        _animationController.forward();
                      },
                      icon: Icon(
                        showDetails ? Icons.close : Icons.info_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Detail card (bottom center)
          if (showDetails && (weekData.details?.isNotEmpty ?? false))
            Positioned(
              bottom: 30,
              left: 100,
              right: 100,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'pregnancy_week_${weekData.week}_details_${currentDetailIndex}'
                                .tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.primaryText,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Detail indicator dots
                              ...List.generate(
                                  weekData.details!.length,
                                  (index) => Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: index == currentDetailIndex
                                              ? NeoSafeColors.primaryPink
                                              : NeoSafeColors.primaryPink
                                                  .withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                      )),
                              const SizedBox(width: 20),
                              // Next button
                              Container(
                                decoration: BoxDecoration(
                                  gradient: NeoSafeGradients.primaryGradient,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: NeoSafeColors.primaryPink
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: _showNextDetail,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
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
}
