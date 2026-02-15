import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/view/map/widgets/google_map_widget.dart';
import 'package:frontend/view/map/widgets/top_inputs.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../viewmodel/map_viewmodel.dart';

class MapView extends StatefulWidget {
  final Place? start;
  final Place? end;
  final Function(BuildContext, MapViewModel) onSeeItineraryTap;
  final Function(BuildContext) onBackTap;

  const MapView({
    super.key,
    required this.start,
    required this.end,
    required this.onSeeItineraryTap,
    required this.onBackTap,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
    if (widget.start == null || widget.end == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MapViewModel>()
        ..updateControllers(start: widget.start!.name, dest: widget.end!.name)
        ..getItinerary(widget.start!, widget.end!);
    });
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
              onBackTap: () => widget.onBackTap(context),
              startController: vm.startController,
              destController: vm.destController,
              onSearchTap: () => vm.getItinerary(widget.start!, widget.end!),
            ),

            Expanded(
              child: Stack(
                children: [
                  // map
                  GoogleMapWidget(
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
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: _bottomCard(vm),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomCard(MapViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.componentBg,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  widget.onSeeItineraryTap(context, vm);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 28,
                    top: 16,
                    bottom: 20,
                    right: 28,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            'Voir itinéraire',
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.secondaryMain,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'Consultez la liste des bus à prendre.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.grey50,
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.primaryMain,
                        child: Icon(
                          Icons.arrow_forward,
                          color: AppColors.secondaryShade100,
                          opticalSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
