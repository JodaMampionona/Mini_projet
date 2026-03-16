import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/stop_model.dart';
import 'package:frontend/viewmodel/bus_viewmodel.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class BusListView extends StatefulWidget {
  final Function(List<Stop> busStops, String? busName) onItemTap;

  const BusListView({super.key, required this.onItemTap});

  @override
  State<BusListView> createState() => _BusListViewState();
}

class _BusListViewState extends State<BusListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BusListViewModel>();
      if (vm.buses.isEmpty) vm.fetchBuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusListViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 44,
          child: AppTextField(
            validator: null,
            icon: Icons.search,
            hintText: 'Rechercher un bus',
            controller: vm.searchController,
          ),
        ),
        backgroundColor: AppColors.primaryTint100,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: vm.loading || vm.busLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryMain),
                  if (vm.loading) Text('Récupération de la liste des bus...'),
                ],
              ),
            )
          : vm.errorMsg != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  SvgPicture.asset(
                    height: 170,
                    AppIllustrations.noData,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16),
                  Text(vm.errorMsg!),
                  ElevatedButton(
                    onPressed: () => vm.fetchBuses(),
                    child: Text('Réessayer'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => vm.fetchBuses(),
              elevation: 0.5,
              color: AppColors.primaryMain,
              backgroundColor: AppColors.componentBg,
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

                            widget.onItemTap(vm.busStops, vm.selectedBusName);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  color:
                                                      AppColors.secondaryMain,
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
                                            terminus?.name ?? 'aucune donnée',
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
                        SizedBox(height: 8),
                      ],
                    ),
                  );
                }).toList(),
              ),
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
