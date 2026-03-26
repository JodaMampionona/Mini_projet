import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/viewmodel/bus_list_viewmodel.dart';
import 'package:frontend/widgets/custom_icon_button.dart';

class StopListTab extends StatelessWidget {
  final ScrollController scrollController;
  final BusListViewModel vm;
  final Function(BusStop stop) onStopTap;

  const StopListTab({
    super.key,
    required this.vm,
    required this.onStopTap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (vm.stopLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryMain),
      );
    }

    if (vm.stopErrorMsg != null) {
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
              child: Text(vm.stopErrorMsg!, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            CustomIconButton(
              onTap: () => vm.fetchStops(),
              label: "Réessayer",
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      elevation: 0.5,
      color: AppColors.primaryMain,
      backgroundColor: AppColors.componentBg,
      onRefresh: () async => vm.fetchStops(reset: true),
      child: Scrollbar(
        controller: scrollController,
        radius: Radius.circular(4),
        interactive: true,
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: vm.stops.length,
          itemBuilder: (context, index) {
            final stop = vm.stops[index];
            final previousStop = index > 0 ? vm.stops[index - 1] : null;
            final isNewZone = stop.zone != previousStop?.zone;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isNewZone) ...[
                    if (index != 0) const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Text(
                        stop.zone ?? 'Zone inconnue',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                  InkWell(
                    onTap: () => onStopTap(stop),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.componentBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primaryMain.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.place,
                                color: AppColors.primaryMain,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                stop.name,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.secondaryMain,
                                      fontWeight: FontWeight.w500,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.grey70,
                              size: 20,
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
          },
        ),
      ),
    );
  }
}
