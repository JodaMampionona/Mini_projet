import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/viewmodel/search_viewmodel.dart';
import 'package:frontend/widgets/app_flushbar.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  final String inputPlaceholder;
  final Function(BusStop) onBusStopTap;
  final bool showGeolocationPrompt;

  const SearchView({
    super.key,
    required this.inputPlaceholder,
    required this.onBusStopTap,
    required this.showGeolocationPrompt,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _showErrorMsg = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().requestInputFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm.errorMsg != null && _showErrorMsg) {
        Future.delayed(Duration(seconds: 3), () {
          if (context.mounted) {
            AppFlushBar.showInfo(context, message: vm.errorMsg!);
          }
        });

        _showErrorMsg = false;
        Timer(Duration(seconds: 10), () {
          _showErrorMsg = true;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        scrolledUnderElevation: 0,
        title: AppTextField(
          validator: null,
          hintText: widget.inputPlaceholder,
          focusNode: vm.focusNode,
          controller: vm.placeController,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 8),
          _buildGeolocation(vm),
          _buildTitle(context),
          SizedBox(height: 8),
          _buildContent(vm),
        ],
      ),
    );
  }

  Widget _buildGeolocation(SearchViewModel vm) {
    if (!widget.showGeolocationPrompt) return const SizedBox();

    if (vm.positionLoading) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Text('Récupération de votre position...'),
                  SizedBox(height: 8),
                  CircularProgressIndicator(color: AppColors.primaryMain),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: vm.fetchPlacesByPosition,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.componentBg,
          child: Row(
            children: [
              Icon(Icons.near_me, color: AppColors.primaryMain),
              const SizedBox(width: 8),
              Text(
                'Utiliser ma position actuelle',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryShade50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        'Arrêts proches',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.grey40),
      ),
    );
  }

  Widget _buildContent(SearchViewModel vm) {
    if (vm.loading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryMain),
      );
    }

    if (vm.searchResponse == null || vm.searchResponse!.stops.isEmpty) {
      return SizedBox.shrink();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: vm.searchResponse!.stops.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final stop = vm.searchResponse!.stops[index];
        final previousStop = index > 0
            ? vm.searchResponse!.stops[index - 1]
            : null;
        final isNewZone = stop.zone != previousStop?.zone;

        final buses = stop.bus;
        final busName = (buses != null && buses.isNotEmpty)
            ? buses.first.name
            : null;

        if (busName == null) return SizedBox.shrink();

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
                onTap: () =>
                    widget.onBusStopTap(vm.searchResponse!.stops[index]),
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
    );
  }
}
