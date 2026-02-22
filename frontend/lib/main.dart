import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/router/router.dart';
import 'package:frontend/services/app_preferences_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryTint100,
        appBarTheme: const AppBarThemeData(
          backgroundColor: AppColors.primaryTint100,
        ),
        // button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.secondaryMain,
            foregroundColor: AppColors.primaryTint100,
            shadowColor: Colors.transparent,
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
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.grey50),
          ),
        ),

        // input
        inputDecorationTheme: InputDecorationTheme(
          hintFadeDuration: Duration(milliseconds: 200),
          filled: true,
          fillColor: AppColors.grey95,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
            context,
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
          displayLarge: GoogleFonts.manrope(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryShade100,
          ),
          displayMedium: GoogleFonts.manrope(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryShade100,
          ),
          displaySmall: GoogleFonts.manrope(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryShade100,
          ),

          // headline
          headlineLarge: GoogleFonts.manrope(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryShade100,
          ),
          headlineMedium: GoogleFonts.manrope(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryShade100,
          ),
          headlineSmall: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryShade100,
          ),

          // title
          titleLarge: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryShade100,
          ),
          titleMedium: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryShade100,
          ),
          titleSmall: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryShade100,
          ),

          // body
          bodyLarge: GoogleFonts.workSans(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: AppColors.secondaryShade100,
          ),
          bodyMedium: GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.grey40,
          ),
          bodySmall: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.grey40,
          ),

          // label
          labelLarge: GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryShade100,
          ),
          labelMedium: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryShade100,
          ),
          labelSmall: GoogleFonts.workSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryShade100,
          ),
        ),
      ),
    );
  }
}
