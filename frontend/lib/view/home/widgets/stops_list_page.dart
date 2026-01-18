import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_stop_model.dart';

class StopsListPage extends StatefulWidget {
  final List<BusStop> stops;
  final String inputPlaceholder;
  final Function(BusStop) onStopTap;

  const StopsListPage({
    super.key,
    required this.stops,
    required this.inputPlaceholder,
    required this.onStopTap,
  });

  @override
  State<StopsListPage> createState() => _StopsListPageState();
}

class _StopsListPageState extends State<StopsListPage> {
  late List<BusStop> filteredStops;

  @override
  void initState() {
    super.initState();
    filteredStops = [...widget.stops];
  }

  @override
  Widget build(BuildContext context) {
    // regroupement des arrets
    final Map<String, List<BusStop>> groupedStops = {};
    for (var stop in filteredStops) {
      groupedStops.putIfAbsent(stop.bus, () => []).add(stop);
    }

    final List<Widget> listItems = [];
    groupedStops.forEach((bus, stops) {
      // nom du bus
      listItems.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: [
              Icon(
                Icons.directions_bus,
                color: AppColors.secondaryMain,
                size: 24,
              ),
              Expanded(
                child: Text(
                  bus,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.secondaryMain,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );

      // Stops pour ce bus
      for (var stop in stops) {
        listItems.add(
          ListTile(
            tileColor: AppColors.componentBg,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            title: Text(stop.name),
            subtitle: Text(
              stop.bus,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.grey50),
            ),
            onTap: () => widget.onStopTap(stop),
          ),
        );
      }
    });

    return widget.stops.isEmpty
        ? Center(child: Text('Aucun arrêt disponible pour le moment.'))
        : Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 50,
                  bottom: 20,
                ),
                color: AppColors.secondaryMain,
                child: SearchBar(
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search, color: AppColors.grey50),
                  ),
                  hintText: widget.inputPlaceholder,
                  onChanged: (value) {
                    setState(() {
                      filteredStops = widget.stops
                          .where(
                            (stop) => stop.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemCount: listItems.length,
                  itemBuilder: (_, index) => listItems[index],
                ),
              ),
            ],
          );
  }
}
