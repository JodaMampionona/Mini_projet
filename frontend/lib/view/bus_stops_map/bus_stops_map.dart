import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/model/stop_model.dart';
import 'package:frontend/view/map/widgets/google_map_widget.dart';
import 'package:go_router/go_router.dart';

class BusStopsMap extends StatefulWidget {
  final List<Stop> stops;
  final String busName;

  const BusStopsMap({super.key, required this.stops, required this.busName});

  @override
  State<BusStopsMap> createState() => _BusStopsMapState();
}

class _BusStopsMapState extends State<BusStopsMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Container(
          constraints: BoxConstraints(minWidth: 200),
          decoration: BoxDecoration(
            color: AppColors.primaryTint100,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              widget.busName,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: CircleAvatar(
            backgroundColor: AppColors.primaryTint100,
            child: Icon(Icons.arrow_back, color: AppColors.secondaryMain),
          ),
        ),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                SizedBox(
                  height: constraints.maxHeight / 2,
                  child: GoogleMapWidget(
                    showIntermediateStops: false,
                    itinerary: widget.stops
                        .map(
                          (stop) => Itinerary(
                            bus: widget.busName,
                            from: stop.name,
                            to: stop.name,
                            startLat: stop.lat,
                            startLon: stop.lon,
                            endLat: stop.lat,
                            endLon: stop.lon,
                          ),
                        )
                        .toList(),
                    compassEnabled: false,
                  ),
                ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryTint100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.directions_bus,
                            color: AppColors.secondaryMain,
                          ),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.secondaryMain),
                              children: [
                                TextSpan(text: 'Liste des arrêts '),
                                TextSpan(
                                  text: '(ligne ${widget.busName})',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.grey50),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(color: AppColors.grey95),

                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: scrollController,
                          itemCount: widget.stops.length,
                          itemBuilder: (context, index) {
                            final stop = widget.stops[index];
                            final isFirst = index == 0;
                            final isLast = index == widget.stops.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Column(
                                      children: [
                                        // ligne en haut
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: isFirst
                                                ? Colors.transparent
                                                : AppColors.secondaryMain,
                                          ),
                                        ),

                                        // bus stop rank
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: isFirst || isLast
                                              ? AppColors.primaryMain
                                              : AppColors.secondaryMain,
                                          child: Text(
                                            stop.order.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: AppColors.componentBg,
                                                ),
                                          ),
                                        ),

                                        // ligne en bas
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            color: isLast
                                                ? Colors.transparent
                                                : AppColors.secondaryMain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // stop name
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        stop.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
