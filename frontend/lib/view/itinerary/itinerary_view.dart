import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/viewmodel/itinerary_viewmodel.dart';
import 'package:provider/provider.dart';

class ItineraryView extends StatefulWidget {
  final Function(BuildContext context) onBackPress;
  final int start;
  final int dest;

  const ItineraryView({
    super.key,
    required this.onBackPress,
    required this.start,
    required this.dest,
  });

  @override
  State<ItineraryView> createState() => _ItineraryViewState();
}

class _ItineraryViewState extends State<ItineraryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItineraryViewModel>().getItinerary(
        widget.start,
        widget.dest,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ItineraryViewModel>();
    final itinerary = viewModel.itinerary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Itinéraire recommandé'),
        leading: BackButton(onPressed: () => widget.onBackPress(context)),
      ),
      body: viewModel.loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.accentMain),
                  SizedBox(height: 16),
                  Text(
                    'Chargement de l\'itinéraire',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.placeholder,
                    ),
                  ),
                ],
              ),
            )
          : itinerary.isEmpty
          ? Center(child: Text('Aucun itinéraire disponible.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.accentDark,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      spacing: 20,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.lightBg,
                        ),
                        Expanded(
                          child: Text(
                            itinerary[0].from,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.lightBg),
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.lightBg,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            itinerary[itinerary.length - 1].to,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.lightBg),
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

                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.directions_bus,
                                  color: AppColors.accentMain,
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
