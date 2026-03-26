import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class AppActionChip extends StatelessWidget {
  final Widget label;
  final IconData? icon;
  final Color bgColor;
  final Color iconColor;
  final Function()? onPressed;

  const AppActionChip({
    super.key,
    required this.label,
    this.icon,
    this.bgColor = AppColors.primaryTint50,
    this.iconColor = AppColors.secondaryShade100,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) Icon(icon, size: 16, color: iconColor),
                    if (icon != null) const SizedBox(width: 4),
                    label,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
