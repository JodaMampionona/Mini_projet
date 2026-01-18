import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/app_text_styles.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

class ItineraryView extends StatefulWidget {
  final Function(BuildContext) onBackPress;
  final Function(BuildContext) onNewItineraryTap;
  final List<Itinerary>? itinerary;

  const ItineraryView({
    super.key,
    required this.onBackPress,
    required this.onNewItineraryTap,
    this.itinerary,
  });

  @override
  State<ItineraryView> createState() => _ItineraryViewState();
}

class _ItineraryViewState extends State<ItineraryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItineraryViewModel>().setItinerary(widget.itinerary ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ItineraryViewModel>();
    final itinerary = viewModel.itinerary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Itinéraire'),
        leading: BackButton(onPressed: () => widget.onBackPress(context)),
      ),
      body: viewModel.loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryMain),
                  SizedBox(height: 16),
                  Text(
                    'Chargement de l\'itinéraire',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.grey50),
                  ),
                ],
              ),
            )
          : itinerary.isEmpty
          ? Center(
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Aucun itinéraire.", style: AppTextStyles.bodyMedium),
                  ElevatedButton(
                    onPressed: () => widget.onNewItineraryTap(context),
                    child: Text('Nouvel itinéraire'),
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
