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
  final Function(Bus bus) onBusTap;
  final Function(BusStop stop) onStopTap;

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
  late ScrollController _busScrollController;
  late ScrollController _stopScrollController;

  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _busScrollController = ScrollController();
    _stopScrollController = ScrollController();

    _busScrollController.addListener(_updateFab);
    _stopScrollController.addListener(_updateFab);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BusListViewModel>();
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          vm.setActiveTab(_tabController.index == 0);
          _updateFab();
        }
      });
      if (vm.buses.isEmpty) vm.fetchBuses();
      if (vm.stops.isEmpty) vm.fetchStops();
    });
  }

  void _updateFab() {
    final controller = _tabController.index == 0
        ? _busScrollController
        : _stopScrollController;
    final show = controller.hasClients && controller.offset > 200;
    if (show != _showFab) setState(() => _showFab = show);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _busScrollController.removeListener(_updateFab);
    _stopScrollController.removeListener(_updateFab);
    _busScrollController.dispose();
    _stopScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusListViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const SizedBox(height: 8),
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
          labelColor: AppColors.secondaryShade100,
          unselectedLabelColor: AppColors.grey40,
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
          BusListTab(
            vm: vm,
            onBusTap: widget.onBusTap,
            scrollController: _busScrollController,
          ),
          StopListTab(
            vm: vm,
            onStopTap: widget.onStopTap,
            scrollController: _stopScrollController,
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              backgroundColor: AppColors.secondaryMain,
              foregroundColor: AppColors.primaryTint100,
              shape: const CircleBorder(),
              elevation: 0.5,
              onPressed: () {
                final controller = _tabController.index == 0
                    ? _busScrollController
                    : _stopScrollController;
                controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : null,
    );
  }
}
