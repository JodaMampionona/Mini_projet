import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/stop_model.dart';
import 'package:frontend/view/bus_list/widgets/bus_list_tab.dart';
import 'package:frontend/view/bus_list/widgets/stop_list_tab.dart';
import 'package:frontend/viewmodel/bus_list_viewmodel.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

class BusListView extends StatefulWidget {
  final Function(List<Stop> busStops, String? busName) onBusTap;
  final Function(List<Bus> buses, Stop stop) onStopTap;

  const BusListView({
    super.key,
    required this.onBusTap,
    required this.onStopTap,
  });

  @override
  State<BusListView> createState() => _BusListViewState();
}

class _BusListViewState extends State<BusListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BusListViewModel>();
      if (vm.buses.isEmpty) vm.fetchBuses();
      if (vm.stops.isEmpty) vm.fetchStops();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusListViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(height: 8),
            AppTextField(
              validator: null,
              icon: Icons.search,
              hintText: 'Rechercher bus, arrêt...',
              controller: vm.searchController,
            ),
          ],
        ),
        backgroundColor: AppColors.primaryTint100,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: AppColors.grey95,
          indicatorColor: AppColors.primaryMain,
          indicatorWeight: 2,
          labelColor: AppColors.primaryMain,
          unselectedLabelColor: AppColors.grey60,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          tabs: const [
            Tab(
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.directions_bus, size: 18), Text('Bus')],
              ),
            ),
            Tab(
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.location_on, size: 18), Text('Arrêts')],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BusListTab(vm: vm, onBusTap: widget.onBusTap),
          StopListTab(vm: vm, onStopTap: widget.onStopTap),
        ],
      ),
    );
  }
}
