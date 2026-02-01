import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/app_text_styles.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/viewmodel/search_viewmodel.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  final String inputPlaceholder;
  final Function(Place) onPlaceTap;

  const SearchView({
    super.key,
    required this.inputPlaceholder,
    required this.onPlaceTap,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().requestInputFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: AppTextField(
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
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: AppColors.errorBg,
                child: Text(
                  vm.errorMsg!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.errorText,
                  ),
                ),
              ),
            SizedBox(height: 16),

            // for geolocation
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
                      await vm.getCurrentLocation();
                      if (vm.currentLocation != null) {
                        widget.onPlaceTap(vm.currentLocation!);
                      }
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

            // list of results
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Lieux trouvés',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey40,
                ),
              ),
            ),

            vm.loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryMain,
                    ),
                  )
                : Container(
                    color: AppColors.componentBg,
                    child: Column(
                      children: [
                        for (int i = 0; i < vm.places.length; i++) ...[
                          ListTile(
                            contentPadding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            onTap: () => widget.onPlaceTap(
                              Place(
                                name: vm.places[i].name,
                                city: vm.places[i].city,
                                lat: vm.places[i].lat,
                                lon: vm.places[i].lon,
                              ),
                            ),
                            tileColor: AppColors.componentBg,
                            title: Text(
                              vm.places[i].name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.secondaryShade100,
                              ),
                            ),
                            subtitle: vm.places[i].city != null
                                ? Text(
                                    vm.places[i].city!,
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

                          if (i != vm.places.length - 1)
                            const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: AppColors.grey95,
                            ),
                        ],
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
