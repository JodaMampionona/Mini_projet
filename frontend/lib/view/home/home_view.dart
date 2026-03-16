import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:frontend/widgets/confirm_dialog.dart';
import 'package:frontend/widgets/history_item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final Function() onSearchItineraryPress;
  final Function(HomeViewModel) onHistoryPress;
  final Function(Place, Place) onHistoryItemTap;

  const HomeView({
    super.key,
    required this.onSearchItineraryPress,
    required this.onHistoryPress,
    required this.onHistoryItemTap,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<HomeViewModel>();
    vm.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return SafeArea(
      child: Column(
        children: [
          // TopBar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BeTax', style: Theme.of(context).textTheme.headlineSmall),
                Text(
                  'Antananarivo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),

          // welcome message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              spacing: 4,
              children: [
                Text(
                  vm.isFirstTime ? 'Bienvenue' : 'Re-bienvenue',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Trouvez votre itinéraire.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // illustration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: SvgPicture.asset(AppIllustrations.busStop, fit: BoxFit.fill),
          ),

          // search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: SearchBar(
              readOnly: true,
              onTap: widget.onSearchItineraryPress,
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryMain),
              hintText: 'Où voulez-vous aller ?',
              hintStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryShade100,
                ),
              ),
              trailing: [
                Icon(Icons.search, color: AppColors.secondaryShade100),
              ],
            ),
          ),

          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: AppColors.grey90,
          ),

          SizedBox(height: 16),

          // history
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trajet le plus récent',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.secondaryMain,
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onHistoryPress(vm),
                  child: Text(
                    'Voir tout',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: AppColors.grey50),
                  ),
                ),
              ],
            ),
          ),

          vm.history.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Aucun trajet pour le moment.',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey70,
                        ),
                      ),
                    ],
                  ),
                )
              : HistoryItem(
                  historyEntry: vm.history[0],
                  onItemTap: () => widget.onHistoryItemTap(
                    vm.history[0].start,
                    vm.history[0].end,
                  ),
                  onDeleteTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmDialog(
                        title:
                            'Supprimer  "${vm.history[0].end.name}"  de votre historique ?',
                        onConfirm: () {
                          vm.deleteFromHistory(vm.history[0]);
                          context.pop();
                        },
                        onCancel: () => context.pop(),
                        confirmLabel: 'Supprimer',
                        cancelLabel: 'Annuler',
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
