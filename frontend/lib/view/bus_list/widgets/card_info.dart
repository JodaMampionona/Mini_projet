import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class CardInfo extends StatelessWidget {
  final String label;
  final String value;

  const CardInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$label : ',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryMain),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
