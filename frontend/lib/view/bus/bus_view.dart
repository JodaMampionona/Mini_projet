import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/viewmodel/bus_viewmodel.dart';
import 'package:provider/provider.dart';

class BusView extends StatefulWidget {
  const BusView({super.key});

  @override
  State<BusView> createState() => _BusViewState();
}

class _BusViewState extends State<BusView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BusViewModel>();
      if (vm.buses.isEmpty) vm.fetchBuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Liste des bus')),
      body: Column(
        spacing: 16,
        children: [
          vm.loading
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 32,
                      children: [
                        CircularProgressIndicator(color: AppColors.primaryMain),
                        Text('Récupération de la liste des bus...'),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: vm.buses
                        .map((bus) => ListTile(title: Text(bus.name)))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
