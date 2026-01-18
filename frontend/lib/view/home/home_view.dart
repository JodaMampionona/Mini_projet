import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/view/home/widgets/card_form.dart';
import 'package:frontend/view/home/widgets/stops_list_page.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final Function(BuildContext, HomeViewModel) onSearchItineraryPress;
  final Function(HomeViewModel) onSwapPress;

  const HomeView({
    super.key,
    required this.onSearchItineraryPress,
    required this.onSwapPress,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final vm = context.read<HomeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchStopsWithBuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Rechercher un itinéraire'),
        automaticallyImplyLeading: false,
      ),
      body: viewModel.loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryMain),
                  SizedBox(height: 16),
                  Text(
                    'Chargement en cours...',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.grey50),
                  ),
                ],
              ),
            )
          : viewModel.busStops.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Vérifiez votre connexion internet.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryShade100,
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.fetchStopsWithBuses();
                    },
                    child: Text('Réessayer'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BeTax',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Antananarivo',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                    SizedBox(height: 30),
                    // form
                    SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: CardForm(
                          vm: viewModel,
                          formKey: _formKey,
                          onSearchItineraryPress: (context) =>
                              widget.onSearchItineraryPress(context, viewModel),
                          onSwapPress: () => widget.onSwapPress(viewModel),
                          onStartTap: () async {
                            final selectedStop = await openFullScreenPage(
                              context,
                              StopsListPage(
                                inputPlaceholder: 'Votre arrêt de départ',
                                stops: viewModel.busStops,
                                onStopTap: (busStop) {
                                  Navigator.of(context).pop(busStop);
                                },
                              ),
                            );
                            if (selectedStop != null) {
                              viewModel.updateStartController(selectedStop);
                            }
                          },
                          onDestTap: () async {
                            final selectedStop = await openFullScreenPage(
                              context,
                              StopsListPage(
                                inputPlaceholder: 'Votre destination',
                                stops: viewModel.busStops,
                                onStopTap: (busStop) {
                                  Navigator.of(context).pop(busStop);
                                },
                              ),
                            );
                            if (selectedStop != null) {
                              viewModel.updateDestController(selectedStop);
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }

  Future<BusStop?> openFullScreenPage(BuildContext context, Widget page) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryTint100,
      builder: (context) => FractionallySizedBox(heightFactor: 1, child: page),
    );
  }
}
