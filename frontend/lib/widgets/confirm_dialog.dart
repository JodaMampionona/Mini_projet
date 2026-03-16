import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String confirmLabel;
  final String cancelLabel;
  final Function() onConfirm;
  final Function() onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsetsGeometry.all(16),
      backgroundColor: AppColors.primaryTint100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      children: [
        ElevatedButton(
          onPressed: onConfirm,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.errorBg),
            foregroundColor: WidgetStatePropertyAll(AppColors.componentBg),
          ),
          child: Text(confirmLabel),
        ),
        TextButton(onPressed: onCancel, child: Text(cancelLabel)),
      ],
    );
  }
}
