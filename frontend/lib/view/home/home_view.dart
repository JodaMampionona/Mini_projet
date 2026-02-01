import 'package:flutter/material.dart';
import 'package:frontend/model/place_model.dart';
import 'package:frontend/view/home/widgets/card_form.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final Function(BuildContext, HomeViewModel) onSearchItineraryPress;
  final Function(BuildContext, HomeViewModel) onStartTap;
  final Function(BuildContext, HomeViewModel) onDestinationTap;
  final Place? start;
  final Place? destination;

  const HomeView({
    super.key,
    required this.onSearchItineraryPress,
    required this.onStartTap,
    required this.onDestinationTap,
    this.start,
    this.destination,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<HomeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.updateStartController(widget.start);
      viewModel.updateDestController(widget.destination);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BeTax', style: Theme.of(context).textTheme.headlineLarge),
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
                    onSearchItineraryPress: () {
                      widget.onSearchItineraryPress(context, viewModel);
                    },
                    onStartTap: () {
                      widget.onStartTap(context, viewModel);
                    },
                    onDestTap: () {
                      widget.onDestinationTap(context, viewModel);
                    },
                    onSwapPress: viewModel.swapStartAndDestination,
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
}
