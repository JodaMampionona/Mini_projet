import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final Function(BuildContext) onSearchItineraryPress;

  const HomeView({super.key, required this.onSearchItineraryPress});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<HomeViewModel>();
    vm.init();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeViewModel>();
    return SafeArea(
      child: Column(
        children: [
          // TopBar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('BeTax', style: Theme.of(context).textTheme.headlineSmall),
                Text(
                  'Antananarivo',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),

          // welcome message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              spacing: 4,
              children: [
                Text(
                  vm.isFirstTime ? 'Bienvenue' : 'Re-bienvenue',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Trouvez votre itinéraire.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // illustration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: SvgPicture.asset(AppIllustrations.busStop, fit: BoxFit.fill),
          ),

          // search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: SearchBar(
              readOnly: true,
              onTap: () => widget.onSearchItineraryPress(context),
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryMain),
              hintText: 'Où voulez-vous aller ?',
              hintStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryShade100,
                ),
              ),
              trailing: [
                Icon(Icons.search, color: AppColors.secondaryShade100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
