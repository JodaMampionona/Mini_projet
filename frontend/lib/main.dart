import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/routes/router.dart';
import 'package:frontend/services/app_preferences_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBg,
        appBarTheme: const AppBarThemeData(backgroundColor: AppColors.lightBg),
        // button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentDark,
            foregroundColor: AppColors.lightBg,
          ),
        ),

        // searchbar
        searchBarTheme: SearchBarThemeData(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(AppColors.inputBackground),
          //padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          hintStyle: WidgetStatePropertyAll(
            Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.placeholder),
          ),
          textStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.bodyLarge,
          ),
        ),

        // input
        inputDecorationTheme: InputDecorationTheme(
          hintFadeDuration: Duration(milliseconds: 200),
          filled: true,
          fillColor: AppColors.inputBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: AppColors.placeholder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.accentDark, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.danger, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: AppColors.danger, width: 1),
          ),
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.placeholder),
        ),

        // curseur
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.textMain,
          selectionColor: AppColors.textSelection,
          selectionHandleColor: AppColors.textMain,
        ),

        textTheme: TextTheme(
          // display
          displayLarge: GoogleFonts.manrope(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
          displayMedium: GoogleFonts.manrope(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
          displaySmall: GoogleFonts.manrope(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),

          // headline
          headlineLarge: GoogleFonts.manrope(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
          headlineMedium: GoogleFonts.manrope(
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
          headlineSmall: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),

          // title
          titleLarge: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
          titleMedium: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textMain,
          ),
          titleSmall: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMain,
          ),

          // body
          bodyLarge: GoogleFonts.workSans(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: AppColors.textMain,
          ),
          bodyMedium: GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),
          bodySmall: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.textSecondary,
          ),

          // label
          labelLarge: GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMain,
          ),
          labelMedium: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMain,
          ),
          labelSmall: GoogleFonts.workSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textMain,
          ),
        ),
      ),
    );
  }
}
