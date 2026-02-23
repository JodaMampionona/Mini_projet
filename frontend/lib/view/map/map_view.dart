import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/view/map/widgets/google_map_widget.dart';
import 'package:frontend/view/map/widgets/top_inputs.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../viewmodel/map_viewmodel.dart';

class MapView extends StatefulWidget {
  final Place? start;
  final Place? end;
  final Function(BuildContext, MapViewModel) onSeeItineraryTap;
  final Function(BuildContext) onBackTap;
  final Function(BuildContext, MapViewModel) onStartTap;
  final Function(BuildContext, MapViewModel) onEndTap;

  const MapView({
    super.key,
    required this.start,
    required this.end,
    required this.onSeeItineraryTap,
    required this.onBackTap,
    required this.onStartTap,
    required this.onEndTap,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    final vm = context.read<MapViewModel>();

    if (widget.start != null) {
      vm.updateStartController(widget.start);
    }
    if (widget.end != null) {
      vm.updateDestController(widget.end);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // inputs on top
            TopInputs(
              onSwapPress: () => vm.swapStartAndDestination(),
              onBackTap: () => widget.onBackTap(context),
              startController: vm.startController,
              destController: vm.destController,
              onSearchTap: () => vm.getItinerary(),
              onStartTap: () => widget.onStartTap(context, vm),
              onEndTap: () => widget.onEndTap(context, vm),
            ),

            Expanded(
              child: Stack(
                children: [
                  // map
                  vm.loading
                      ? Container()
                      : GoogleMapWidget(
                          itinerary: vm.itinerary,
                          compassEnabled: true,
                          showIntermediateStops: true,
                        ),
                  // bottom link
                  vm.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondaryMain,
                          ),
                        )
                      : Positioned(
                          bottom: 16,
                          right: 16,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onSeeItineraryTap(context, vm);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Voir itinéraire"),
                                SizedBox(width: 8),
                                Icon(Icons.route),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
