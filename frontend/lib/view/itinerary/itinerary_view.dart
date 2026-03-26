import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
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
      context.read<ItineraryViewModel>().setItinerary(widget.itinerary);
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
          ? Center(
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
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.secondaryMain,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            itinerary[0].from,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.primaryTint100),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.primaryTint100,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            itinerary[itinerary.length - 1].to,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.primaryTint100),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    spacing: 32,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.route),
                          Text(
                            "${vm.distance.toStringAsFixed(2).toString()} km",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.access_time),
                          Text(
                            vm.durationFormatted,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    separatorBuilder: (_, _) =>
                        Divider(color: Colors.grey[300], height: 50),
                    itemCount: itinerary.length,
                    itemBuilder: (context, index) {
                      final step = itinerary[index];

                      return Column(
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
                              Text(
                                step.bus,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'de : ${step.from}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'à : ${step.to}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
