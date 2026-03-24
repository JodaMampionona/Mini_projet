import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/stop_model.dart';
import 'package:frontend/view/bus_list/widgets/card_info.dart';
import 'package:frontend/viewmodel/bus_list_viewmodel.dart';
import 'package:frontend/widgets/custom_icon_button.dart';

class BusListTab extends StatelessWidget {
  final BusListViewModel vm;
  final Function(List<Stop>, String?) onBusTap;

  const BusListTab({super.key, required this.vm, required this.onBusTap});

  @override
  Widget build(BuildContext context) {
    if (vm.busLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryMain),
      );
    }

    if (vm.busErrorMsg != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              height: 170,
              AppIllustrations.searchEverywhere,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              child: Text(vm.busErrorMsg!, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            CustomIconButton(
              onTap: () => vm.fetchBuses(),
              label: "Réessayer",
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => vm.fetchBuses(),
      elevation: 0.5,
      color: AppColors.primaryMain,
      backgroundColor: AppColors.componentBg,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: vm.buses.map((bus) {
          final primus = bus.stops.firstOrNull;
          final terminus = bus.stops.lastOrNull;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    await vm.fetchBus(bus.id);
                    onBusTap(vm.busStops, vm.selectedBusName);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.componentBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.grey95),
                                left: BorderSide(color: AppColors.grey95),
                                right: BorderSide(color: AppColors.grey95),
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
                                children: [
                                  Icon(
                                    Icons.directions_bus,
                                    color: AppColors.grey50,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    bus.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.secondaryMain,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CardInfo(
                                    label: 'Primus',
                                    value: primus?.name ?? 'aucune donnée',
                                  ),
                                  const SizedBox(height: 4),
                                  CardInfo(
                                    label: 'Terminus',
                                    value: terminus?.name ?? 'aucune donnée',
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
                const SizedBox(height: 8),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
