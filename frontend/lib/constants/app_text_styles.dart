import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle display = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    color: AppColors.secondaryShade100,
  );

  static final TextStyle headline = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    color: AppColors.secondaryShade100,
  );

  static final TextStyle title = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    color: AppColors.secondaryShade100,
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    color: AppColors.secondaryShade100,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    color: AppColors.secondaryShade100,
  );

  static final TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
    color: AppColors.secondaryShade100,
  );
}
