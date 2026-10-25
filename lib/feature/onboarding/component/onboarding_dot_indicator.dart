import 'package:flutter/material.dart';
import 'package:nuqta/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class OnboardingDotIndicator extends StatelessWidget {
  final int totalDots;
  final int currentIndex;
  final ValueChanged<int>? onDotTap;

  const OnboardingDotIndicator({
    super.key,
    this.totalDots = 3,
    required this.currentIndex,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == currentIndex;
        return GestureDetector(
          onTap: onDotTap != null ? () => onDotTap!(index) : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: isActive ? 6.5.w : 1.8.w,
              height: 0.9.h,
              decoration: BoxDecoration(
                color: isActive ? AppColors.dotActive : AppColors.dotInactive,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
          ),
        );
      }),
    );
  }
}
