import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/stop_model.dart';
import 'package:frontend/viewmodel/bus_viewmodel.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class BusView extends StatefulWidget {
  final Function(List<Stop> busStops, String busName) onItemTap;

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
                validator: null,
                icon: Icons.search,
                hintText: 'Rechercher un bus',
                controller: vm.searchController,
              ),
            ),
          ),

          vm.busLoading
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 32,
                      children: [
                        CircularProgressIndicator(color: AppColors.primaryMain),
                      ],
                    ),
                  ),
                )
              : vm.loading
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
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: vm.buses.map((bus) {
                      final primus = bus.stops.firstOrNull;
                      final terminus = bus.stops.lastOrNull;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await vm.fetchBus(bus.id);
                                widget.onItemTap(
                                  vm.busStops,
                                  vm.selectedBusName,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.componentBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    spacing: 8,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: AppColors.grey95,
                                            ),
                                            left: BorderSide(
                                              color: AppColors.grey95,
                                            ),
                                            right: BorderSide(
                                              color: AppColors.grey95,
                                            ),
                                            bottom: BorderSide(
                                              color: AppColors.primaryMain,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 8,
                                            children: [
                                              Icon(
                                                Icons.directions_bus,
                                                color: AppColors.grey70,
                                                size: 18,
                                              ),
                                              Text(
                                                bus.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .secondaryMain,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                              info(
                                                'Primus',
                                                primus?.name ?? 'aucune donnée',
                                              ),
                                              info(
                                                'Terminus',
                                                terminus?.name ??
                                                    'aucune donnée',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget info(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$label : ',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.secondaryMain),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
