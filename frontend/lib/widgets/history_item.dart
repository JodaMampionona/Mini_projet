import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/history_model.dart';

class HistoryItem extends StatelessWidget {
  final HistoryEntry historyEntry;
  final Function() onItemTap;
  final Function() onDeleteTap;

  const HistoryItem({
    super.key,
    required this.historyEntry,
    required this.onItemTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16, right: 16),
      onTap: onItemTap,
      tileColor: AppColors.componentBg,
      title: Text(
        historyEntry.end.name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryShade100),
      ),
      subtitle: Text(
        'origine : ${historyEntry.start.name}',
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.grey70),
      ),
      trailing: IconButton(
        onPressed: onDeleteTap,
        icon: Icon(Icons.close, color: AppColors.grey70),
      ),
    );
  }
}
