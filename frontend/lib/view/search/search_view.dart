import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/viewmodel/search_viewmodel.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:frontend/widgets/error_message.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  final String inputPlaceholder;
  final Function(Place) onPlaceTap;
  final bool showGeolocationPrompt;

  const SearchView({
    super.key,
    required this.inputPlaceholder,
    required this.onPlaceTap,
    required this.showGeolocationPrompt,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
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
          _buildError(vm),
          _buildGeolocation(vm),
          _buildTitle(context),
          SizedBox(height: 8),
          _buildContent(vm),
        ],
      ),
    );
  }

  // ---------------- UI SECTIONS ----------------

  Widget _buildError(SearchViewModel vm) {
    if (vm.errorMsg == null) return const SizedBox();

    return Column(
      children: [
        ErrorMessage(message: vm.errorMsg!),
        const SizedBox(height: 16),
      ],
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
      padding: EdgeInsets.only(bottom: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.searchResponse!.stops.length,
      itemBuilder: (context, index) {
        final stop = vm.searchResponse!.stops[index];
        final buses = stop.bus;

        final busName = (buses != null && buses.isNotEmpty)
            ? buses.first.name
            : null;

        if (busName == null) return SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => widget.onPlaceTap(
              Place(name: stop.name, city: '', lat: stop.lat, lon: stop.lon),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.componentBg,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.secondaryMain,
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          busName,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: AppColors.grey70),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.grey70),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryMain.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.place, color: AppColors.primaryMain, size: 20),
    );
  }
}
