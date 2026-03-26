import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import '../constants/app_colors.dart';

class AppFlushBar {
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    Flushbar(
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.componentBg,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: AppColors.errorBg,
      flushbarPosition: position,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    Flushbar(
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.primaryTint100,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: AppColors.secondaryMain,
      icon: Icon(Icons.info_outline, color: AppColors.primaryTint100),
      flushbarPosition: position,
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    Flushbar(
      messageText: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.green[600]!,
      flushbarPosition: position,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      animationDuration: const Duration(milliseconds: 300),
    ).show(context);
  }
}
