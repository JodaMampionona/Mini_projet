import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/itinerary_model.dart';
import 'package:frontend/view/map/widgets/google_map_widget.dart';
import 'package:frontend/viewmodel/bus_details_viewmodel.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BusDetailsView extends StatefulWidget {
  final Bus bus;

  const BusDetailsView({super.key, required this.bus});

  @override
  State<BusDetailsView> createState() => _BusDetailsViewState();
}

class _BusDetailsViewState extends State<BusDetailsView> {
  late final DraggableScrollableController _sheetController;
  double _mapOffset = 0.0;
  bool _sheetVisible = true;

  static const double _initialSize = 0.3;
  static const double _maxSize = 0.7;
  static const double _parallaxFactor = 0.5;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(_onSheetChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<BusDetailsViewModel>();
      vm.fetchBus(widget.bus.id);
    });
  }

  void _onSheetChanged() {
    if (!_sheetController.isAttached) return;
    final size = _sheetController.size;
    final t = ((size - _initialSize) / (_maxSize - _initialSize)).clamp(
      0.0,
      1.0,
    );
    setState(() {
      _mapOffset =
          -t *
          MediaQuery.of(context).size.height *
          _parallaxFactor *
          (_maxSize - _initialSize);
    });
  }

  void _dismissSheet() {
    setState(() {
      _sheetVisible = false;
      _mapOffset = 0.0; // full screen
    });
    _sheetController.jumpTo(_initialSize);
  }

  void _showSheet() {
    setState(() => _sheetVisible = true);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusDetailsViewModel>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: CircleAvatar(
            backgroundColor: AppColors.primaryTint100,
            child: Icon(Icons.arrow_back, color: AppColors.secondaryMain),
          ),
        ),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              height: _sheetVisible
                  ? constraints.maxHeight * 0.7
                  : constraints.maxHeight,
              child: Transform.translate(
                offset: Offset(0, _mapOffset),
                child: vm.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryMain,
                        ),
                      )
                    : GoogleMapWidget(
                        showIntermediateStops: true,
                        itinerary: vm.bus != null
                            ? vm.bus!.stops
                                  .map(
                                    (stop) => Itinerary(
                                      bus: widget.bus.name,
                                      from: stop.name,
                                      to: stop.name,
                                      startLat: stop.lat,
                                      startLon: stop.lon,
                                      endLat: stop.lat,
                                      endLon: stop.lon,
                                      busStops: [],
                                    ),
                                  )
                                  .toList()
                            : [],
                        compassEnabled: false,
                      ),
              ),
            ),
          ),

          // Sheet avec animation de sortie
          AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            offset: _sheetVisible ? Offset.zero : const Offset(0, 1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _sheetVisible ? 1.0 : 0.0,
              child: DraggableScrollableSheet(
                initialChildSize: _initialSize,
                minChildSize: _initialSize,
                maxChildSize: _maxSize,
                controller: _sheetController,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Liste des arrêts',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                  Text('Ligne ${widget.bus.name}'),
                                ],
                              ),
                              IconButton(
                                onPressed: _dismissSheet,
                                icon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ],
                          ),
                          Divider(color: AppColors.grey95),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              itemCount: vm.bus?.stops.length ?? 0,
                              itemBuilder: (context, index) {
                                final stop = vm.bus!.stops[index];
                                final isFirst = index == 0;
                                final isLast =
                                    index == vm.bus!.stops.length - 1;

                                return vm.bus == null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nous n\'avons pas pu récupérer les informations concernant cette ligne de bus.',
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Veuillez vérifier votre connexion internet.',
                                          ),
                                        ],
                                      )
                                    : IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: 2,
                                                      color: isFirst
                                                          ? Colors.transparent
                                                          : AppColors
                                                                .secondaryMain,
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        isFirst || isLast
                                                        ? AppColors.primaryMain
                                                        : AppColors
                                                              .secondaryMain,
                                                    child: Text(
                                                      stop.rank.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            color: AppColors
                                                                .componentBg,
                                                          ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      width: 2,
                                                      color: isLast
                                                          ? Colors.transparent
                                                          : AppColors
                                                                .secondaryMain,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 8,
                                                    ),
                                                child: Text(
                                                  stop.name,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Bouton de rappel
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _sheetVisible ? -80 : 24,
            left: 0,
            right: 0,
            child: Center(
              child: CustomIconButton(
                onTap: _showSheet,
                label: 'Voir les arrêts',
                icon: Icons.keyboard_arrow_up,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
