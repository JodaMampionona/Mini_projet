import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData? icon;
  final Function()? onTap;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      focusNode: focusNode,
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 40, minHeight: 40),
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.grey50) : null,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey40),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        fillColor: AppColors.componentBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
