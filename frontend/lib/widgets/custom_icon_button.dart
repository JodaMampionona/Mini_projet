import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,

      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(
          left: 12,
          right: 16,
          top: 12,
          bottom: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 4,
      ),
    );
  }
}
