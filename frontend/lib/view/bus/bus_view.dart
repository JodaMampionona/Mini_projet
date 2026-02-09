import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/viewmodel/bus_viewmodel.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class BusView extends StatefulWidget {
  final Function(List<Place> busStops, String busName) onItemTap;

  const BusView({super.key, required this.onItemTap});

  @override
  State<BusView> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BusViewModel>();
      if (vm.buses.isEmpty) vm.fetchBuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des bus'),
        backgroundColor: AppColors.primaryTint100,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 48,
              child: AppTextField(
                hintText: 'Rechercher un bus',
                controller: vm.searchController,
              ),
            ),
          ),

          vm.loading
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 32,
                      children: [
                        CircularProgressIndicator(color: AppColors.primaryMain),
                        Text('Récupération de la liste des bus...'),
                      ],
                    ),
                  ),
                )
              : vm.errorMsg != null
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        Text(vm.errorMsg!),
                        ElevatedButton(
                          onPressed: () => vm.fetchBuses(),
                          child: Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: vm.buses.map((bus) {
                      final primus = bus.stops.firstOrNull;
                      final terminus = bus.stops.lastOrNull;

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(4),
                              ),
                              tileColor: AppColors.componentBg,
                              title: Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bus.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              'Primus : ${primus?.name ?? ''}',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              'Terminus : ${terminus?.name ?? ''}',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),

                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryShade50,
                                        ),
                                        onPressed: () {
                                          widget.onItemTap(<Place>[], '');
                                        },
                                        child: Row(
                                          spacing: 4,
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text('Voir sur la carte'),
                                            SizedBox(width: 4),
                                            Icon(Icons.arrow_forward, size: 18),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
