import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/app_text_styles.dart';
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
        padding: EdgeInsets.only(top: 16),
        children: [
          // error message
          if (vm.errorMsg != null)
            Column(
              children: [
                ErrorMessage(message: vm.errorMsg!),
                SizedBox(height: 16),
              ],
            ),

          // for geolocation
          if (widget.showGeolocationPrompt)
            vm.positionLoading
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        spacing: 8,
                        children: [
                          Text('Récupération de votre position...'),
                          CircularProgressIndicator(
                            color: AppColors.primaryMain,
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      await vm.fetchPlacesByPosition();
                    },
                    child: Ink(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: AppColors.componentBg,
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.near_me,
                            color: AppColors.primaryMain,
                            size: 24,
                          ),
                          Text(
                            'Utiliser ma position actuelle',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryShade50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

          if (widget.showGeolocationPrompt) SizedBox(height: 16),

          // list of results
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              'Arrêts proches',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey40),
            ),
          ),

          vm.loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryMain,
                  ),
                )
              : vm.searchResponse != null
              ? Container(
                  color: AppColors.componentBg,
                  child: Column(
                    children: [
                      for (
                        int i = 0;
                        i < vm.searchResponse!.stops.length;
                        i++
                      ) ...[
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 16, right: 16),
                          onTap: () => widget.onPlaceTap(
                            Place(
                              name: vm.searchResponse!.stops[i].name,
                              city: '',
                              lat: vm.searchResponse!.stops[i].lat,
                              lon: vm.searchResponse!.stops[i].lon,
                            ),
                          ),
                          tileColor: AppColors.componentBg,
                          title: Text(
                            vm.searchResponse!.stops[i].name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.secondaryShade100,
                            ),
                          ),
                          subtitle:
                              vm.searchResponse!.stops[i].bus?.name != null
                              ? Text(
                                  vm.searchResponse!.stops[i].bus!.name,
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.grey70,
                                  ),
                                )
                              : null,
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.grey70,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.grey70,
                          ),
                        ),

                        if (i != vm.searchResponse!.stops.length - 1)
                          const Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: AppColors.grey95,
                          ),
                      ],
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
