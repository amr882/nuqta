import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuqta/core/theme/app_colors.dart';
import 'package:nuqta/feature/onboarding/component/onboarding_wave_animation.dart';
import 'package:sizer/sizer.dart';

class OnboardingIllustrationView extends StatelessWidget {
  final int pageIndex;
  final String? svgAsset;

  const OnboardingIllustrationView({
    super.key,
    required this.pageIndex,
    this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: _buildContent());
  }

  Widget _buildContent() {
    if (svgAsset != null) {
      if (pageIndex == 0) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(svgAsset!, fit: BoxFit.contain),
                const OnboardingWaveAnimation(
                  waveCount: 3,
                  maxRadius: 140,
                  strokeWidth: 1.5,
                  centerDotRadius: 5,
                ),
              ],
            ),
          ),
        );
      }

      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: SvgPicture.asset(svgAsset!, fit: BoxFit.contain),
        ),
      );
    }

    if (pageIndex == 1) {
      return Center(
        child: Container(
          width: 65.w,
          height: 65.w,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 32,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.access_time_filled_rounded,
                    size: 11.w,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(5.w),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 4.w,
                          color: const Color(0xFF059669),
                        ),
                        SizedBox(width: 1.5.w),
                        Text(
                          'Verified Live Hours',
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 65.w,
        height: 65.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 32,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.near_me_rounded,
                  size: 11.w,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(5.w),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.navigation_rounded,
                        size: 4.w,
                        color: const Color(0xFF2563EB),
                      ),
                      SizedBox(width: 1.5.w),
                      Text(
                        'Directions & Routing',
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D4ED8),
                        ),
                      ),
                    ],
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
