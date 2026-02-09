import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.errorBg.withAlpha(60),
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.errorText),
      ),
    );
  }
}
