import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/view/itinerary/widgets/itinerary_card.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
import 'package:frontend/widgets/app_action_chip.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class ItineraryView extends StatefulWidget {
  final Function(BuildContext) onBackPress;
  final Function(BuildContext) onNewItineraryTap;
  final List<Itinerary> itinerary;

  const ItineraryView({
    super.key,
    required this.onBackPress,
    required this.onNewItineraryTap,
    required this.itinerary,
  });

  @override
  State<ItineraryView> createState() => _ItineraryViewState();
}

class _ItineraryViewState extends State<ItineraryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ItineraryViewModel>();
      vm.setItinerary(widget.itinerary);
      vm.setCurrentIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryViewModel>();
    final itinerary = vm.itinerary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Itinéraire'),
        leading: BackButton(onPressed: () => widget.onBackPress(context)),
      ),
      body: itinerary.isEmpty
          ? _buildEmptyState()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(itinerary),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildInfo(vm),
                ),

                Divider(
                  color: AppColors.grey95,
                  height: 32,
                  indent: 16,
                  endIndent: 16,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Liste des bus à prendre',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      AppActionChip(
                        icon: Icons.check_circle,
                        label: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.successText),
                            children: [
                              TextSpan(
                                text: "${vm.currentIndex}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: "/${vm.itinerary.length} bus"),
                            ],
                          ),
                        ),
                        bgColor: AppColors.successBg,
                        iconColor: vm.currentIndex == vm.itinerary.length
                            ? AppColors.successText
                            : AppColors.secondaryMain,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    separatorBuilder: (_, _) => SizedBox(height: 16),
                    itemCount: itinerary.length,
                    itemBuilder: (context, index) {
                      final step = itinerary[index];

                      return ItineraryCard(
                        bus: step.bus,
                        from: step.from,
                        to: step.to,
                        isDone: vm.currentIndex > index,
                        onChanged: (checked) {
                          if (checked == null) return;
                          if (!checked) {
                            vm.setCurrentIndex(index);
                          } else {
                            vm.setCurrentIndex(index + 1);
                          }
                        },
                        onContainerTap: () {
                          if (vm.currentIndex > index) {
                            vm.setCurrentIndex(index);
                          } else {
                            vm.setCurrentIndex(index + 1);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Aucun itinéraire pour le moment.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          CustomIconButton(
            onTap: () => widget.onNewItineraryTap(context),
            label: 'Nouvel itinéraire',
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(List<Itinerary> itinerary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        children: [
          Row(
            children: [
              Text('Départ : '),
              Text(
                itinerary[0].from,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),

          Row(
            children: [
              Text('Destination : '),
              Text(
                itinerary[itinerary.length - 1].to,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(ItineraryViewModel vm) {
    return Row(
      spacing: 16,
      children: [
        AppActionChip(
          icon: Icons.route,
          label: Text(
            "${vm.distance.toStringAsFixed(2).toString()} km",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryShade100,
            ),
          ),
        ),

        AppActionChip(
          icon: Icons.access_time_filled,
          label: Text(
            vm.durationFormatted,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryShade100,
            ),
          ),
        ),
      ],
    );
  }
}
