import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/router/routes.dart';
import 'package:frontend/viewmodel/history_viewmodel.dart';
import 'package:frontend/widgets/confirm_dialog.dart';
import 'package:frontend/widgets/history_item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  final Function(Place, Place) onHistoryItemTap;

  const HistoryView({super.key, required this.onHistoryItemTap});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryViewModel>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Historique des trajets'),
            TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return ConfirmDialog(
                    title: 'Supprimer tout votre historique de trajet ?',
                    confirmLabel: 'Supprimer',
                    cancelLabel: 'Annuler',
                    onConfirm: () {
                      vm.clearHistory();
                      context.pop();
                    },
                    onCancel: () => context.pop(),
                  );
                },
              ),
              child: Text(
                'Tout effacer',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.grey50),
              ),
            ),
          ],
        ),
      ),
      body: vm.history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  SvgPicture.asset(
                    height: 170,
                    AppIllustrations.noData,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16),
                  Text('Aucun trajet pour le moment.'),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        Routes.search.name,
                        extra: {'isStart': false, 'from': Routes.history.name},
                      );
                    },
                    child: Text('Nouvel itinéraire'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: vm.history.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.grey95,
              ),
              itemBuilder: (context, index) {
                final entry = vm.history[index];
                return HistoryItem(
                  historyEntry: entry,
                  onItemTap: () =>
                      widget.onHistoryItemTap(entry.start, entry.end),
                  onDeleteTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmDialog(
                        title:
                            'Supprimer  "${entry.end.name}"  de votre historique ?',
                        onConfirm: () {
                          vm.deleteFromHistory(entry);
                          context.pop();
                        },
                        onCancel: () => context.pop(),
                        confirmLabel: 'Supprimer',
                        cancelLabel: 'Annuler',
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
