import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback? onSkip;

  const OnboardingTopBar({super.key, this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: SvgPicture.asset("assets/svg/app_logo.svg"),
    );
  }
}
