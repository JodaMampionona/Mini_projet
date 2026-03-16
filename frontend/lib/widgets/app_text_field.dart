import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String? Function(String?)? validator;
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
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryShade100),
      validator: validator,
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      focusNode: focusNode,
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 40, minHeight: 40),
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.grey70) : null,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.grey50),
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
      ),
    );
  }
}
