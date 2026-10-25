import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuqta/core/theme/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppTextStyles {
  static TextStyle _baseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.notoSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      textStyle: TextStyle(
        fontFamilyFallback: [
          GoogleFonts.notoSansArabic().fontFamily ?? 'Noto Sans Arabic',
        ],
      ),
    );
  }

  static TextStyle notoSansArabic({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.notoSansArabic(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      textStyle: TextStyle(
        fontFamilyFallback: [
          GoogleFonts.notoSans().fontFamily ?? 'Noto Sans',
        ],
      ),
    );
  }

  static TextStyle notoSans({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    double? height,
  }) {
    return _baseStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle get title => _baseStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get subtitle => _baseStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static TextStyle get button => _baseStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static TextStyle get skip => _baseStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get language => _baseStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}

