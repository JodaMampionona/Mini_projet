import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class IconTextField extends StatelessWidget {
  final Icon icon;
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final bool isReadOnly;
  final Function() onTap;

  const IconTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.validator,
    required this.isReadOnly,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Row(
          spacing: 8,
          children: [
            icon,
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        TextFormField(
          readOnly: isReadOnly,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(hintText: placeholder),
          onTap: () => onTap(),
        ),
      ],
    );
  }
}
