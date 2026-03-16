import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final BuildContext _context;

  AppTheme({required BuildContext context}) : _context = context;

  late final theme = ThemeData(
    scaffoldBackgroundColor: AppColors.primaryTint100,
    appBarTheme: const AppBarThemeData(
      backgroundColor: AppColors.primaryTint100,
    ),
    // button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: Theme.of(_context).textTheme.labelLarge,
        elevation: 0,
        backgroundColor: AppColors.secondaryMain,
        foregroundColor: AppColors.primaryTint100,
        shadowColor: Colors.transparent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: Theme.of(_context).textTheme.labelLarge,
        foregroundColor: AppColors.secondaryMain,
        side: BorderSide(color: AppColors.secondaryMain),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondaryMain,
        textStyle: Theme.of(
          _context,
        ).textTheme.labelLarge?.copyWith(color: AppColors.grey90),
      ),
    ),

    // searchbar
    searchBarTheme: SearchBarThemeData(
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: const WidgetStatePropertyAll(AppColors.grey95),
      constraints: BoxConstraints(minHeight: 60),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      hintStyle: WidgetStatePropertyAll(
        Theme.of(
          _context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.grey50),
      ),
    ),

    // input
    inputDecorationTheme: InputDecorationTheme(
      hintFadeDuration: Duration(milliseconds: 200),
      filled: true,
      fillColor: AppColors.grey95,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: AppColors.grey50, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.grey50, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.errorBg, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.errorBg, width: 1),
      ),
      hintStyle: Theme.of(
        _context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.grey50),
    ),

    // cursor
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.secondaryShade100,
      selectionColor: AppColors.textSelection,
      selectionHandleColor: AppColors.secondaryShade100,
    ),

    textTheme: TextTheme(
      // display
      displayLarge: GoogleFonts.dmSans(
        fontSize: 96,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryShade100,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 60,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryShade100,
      ),
      displaySmall: GoogleFonts.dmSans(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryShade100,
      ),

      // headline
      headlineLarge: GoogleFonts.dmSans(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryShade100,
      ),
      headlineMedium: GoogleFonts.dmSans(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryShade100,
      ),
      headlineSmall: GoogleFonts.dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryShade100,
      ),

      // title
      titleLarge: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryShade100,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryShade100,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryShade100,
      ),

      // body
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: AppColors.secondaryShade100,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.grey40,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.grey40,
      ),

      // label
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryShade100,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryShade100,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.secondaryShade100,
      ),
    ),
  );
}
