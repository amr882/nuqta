import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuqta/core/routes/routes.dart';
import 'package:nuqta/core/theme/app_colors.dart';
import 'package:nuqta/feature/onboarding/component/onboarding_bottom_card.dart';
import 'package:nuqta/feature/onboarding/component/onboarding_illustration_view.dart';
import 'package:nuqta/feature/onboarding/component/onboarding_top_bar.dart';
import 'package:nuqta/feature/onboarding/model/onboarding_model.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late final PageController _pageController;
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  final List<OnboardingModel> _pages = const [
    OnboardingModel(
      svgAsset: 'assets/svg/onboarding1.svg',
      title: "See what's open now",
      description: 'Find pharmacies, hospitals, bakeries and\npolice near you.',
    ),
    OnboardingModel(
      svgAsset: 'assets/svg/onboarding2.svg',
      title: 'Pick any hour',
      description:
          'Slide the clock and see what will be open\nwhen you get there.',
    ),
    OnboardingModel(
      svgAsset: 'assets/svg/onboarding3.svg',
      title: 'Help keep it true',
      description:
          'Confirm hours or report changes so\neveryone gets the right answer.',
    ),
  ];

  late final List<Widget> _builtPages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // scroll frame.
    _builtPages = [
      OnboardingIllustrationView(
        key: const ValueKey('onboarding_page_0'),
        pageIndex: 0,
        svgAsset: _pages[0].svgAsset,
      ),
      OnboardingIllustrationView(
        key: const ValueKey('onboarding_page_1'),
        pageIndex: 1,
        svgAsset: _pages[1].svgAsset,
      ),
      OnboardingIllustrationView(
        key: const ValueKey('onboarding_page_2'),
        pageIndex: 2,
        svgAsset: _pages[2].svgAsset,
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final page in _pages) {
        final loader = SvgAssetLoader(page.svgAsset!);
        svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        );
      }
    });
  }

  @override
  void dispose() {
    _currentPage.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, Routes.homeScreen);
  }

  void _onNext() {
    if (_currentPage.value < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    }
  }

  void _onDotTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingTopBar(onSkip: _onSkip),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage.value = index;
                },
                children: _builtPages,
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, page, _) {
                return OnboardingBottomCard(
                  title: _pages[page].title,
                  description: _pages[page].description,
                  currentIndex: page,
                  totalPages: _pages.length,
                  onNext: _onNext,
                  onDotTap: _onDotTap,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
