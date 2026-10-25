import 'package:flutter/material.dart';
import 'package:nuqta/core/theme/app_colors.dart';
import 'package:nuqta/core/theme/app_text_styles.dart';
import 'package:nuqta/feature/onboarding/component/onboarding_dot_indicator.dart';
import 'package:sizer/sizer.dart';

class OnboardingBottomCard extends StatelessWidget {
  final String title;
  final String description;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final ValueChanged<int>? onDotTap;

  const OnboardingBottomCard({
    super.key,
    required this.title,
    required this.description,
    required this.currentIndex,
    this.totalPages = 3,
    required this.onNext,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == totalPages - 1;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.w),
          topRight: Radius.circular(8.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(6.w, 3.5.h, 6.w, 3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  title,
                  key: ValueKey('title_$currentIndex'),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title,
                ),
              ),
              SizedBox(height: 1.5.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  description,
                  key: ValueKey('desc_$currentIndex'),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                ),
              ),
              SizedBox(height: 2.5.h),
              OnboardingDotIndicator(
                totalDots: totalPages,
                currentIndex: currentIndex,
                onDotTap: onDotTap,
              ),
              SizedBox(height: 2.5.h),
              SizedBox(
                width: double.infinity,
                height: 6.2.h,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.5.w),
                    ),
                  ),
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
