import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class ItineraryCard extends StatelessWidget {
  final String bus, from, to;
  final bool isDone;
  final Function(bool? checked) onChanged;
  final Function() onContainerTap;

  const ItineraryCard({
    super.key,
    required this.bus,
    required this.from,
    required this.to,
    required this.isDone,
    required this.onChanged,
    required this.onContainerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.componentBg,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onContainerTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_bus,
                        color: AppColors.primaryMain,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(bus, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  SizedBox(height: 4),

                  Text(
                    'de : $from',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 4),

                  Text('à : $to', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),

              Checkbox(
                value: isDone,
                onChanged: (checked) => onChanged(checked),
                activeColor: AppColors.successText,
                shape: CircleBorder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
