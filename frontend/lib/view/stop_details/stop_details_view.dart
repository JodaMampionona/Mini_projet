import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/model/bus_model.dart';
import 'package:frontend/model/bus_stop_model.dart';
import 'package:frontend/view/map/widgets/google_map_widget.dart';
import 'package:frontend/viewmodel/stop_details_viewmodel.dart';
import 'package:frontend/widgets/app_action_chip.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StopDetailsView extends StatefulWidget {
  final BusStop stop;
  final Function(Bus bus) onBusTap;

  const StopDetailsView({
    super.key,
    required this.stop,
    required this.onBusTap,
  });

  @override
  State<StopDetailsView> createState() => _StopDetailsViewState();
}

class _StopDetailsViewState extends State<StopDetailsView> {
  bool _sheetVisible = true;

  final GlobalKey _sheetContentKey = GlobalKey();
  double _sheetContentHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<StopDetailsViewModel>();
      vm.fetchStop(widget.stop.id);
      _measureSheetHeight();
    });
  }

  void _measureSheetHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _sheetContentKey.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null && mounted) {
          setState(() {
            _sheetContentHeight = box.size.height;
          });
        }
      }
    });
  }

  void _dismissSheet() {
    setState(() => _sheetVisible = false);
  }

  void _showSheet() {
    setState(() => _sheetVisible = true);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StopDetailsViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureSheetHeight());

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
      body: Column(
        children: [
          Expanded(
            child: GoogleMapWidget(
              showIntermediateStops: false,
              stops: vm.stop == null ? [] : [vm.stop!],
              itinerary: [],
              compassEnabled: false,
            ),
          ),

          AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            offset: _sheetVisible ? Offset.zero : const Offset(0, 1),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _sheetVisible
                  ? _buildSheetContent(vm)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),

      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _sheetVisible ? 0.0 : 1.0,
        child: IgnorePointer(
          ignoring: _sheetVisible,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomIconButton(
              onTap: _showSheet,
              label: 'Voir les informations',
              icon: Icons.keyboard_arrow_up,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSheetContent(StopDetailsViewModel vm) {
    return Container(
      key: _sheetContentKey,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryTint100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  vm.stop == null ? 'Arrêt inconnu' : vm.stop!.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: vm.stop == null
                        ? AppColors.grey70
                        : AppColors.secondaryMain,
                    fontStyle: vm.stop == null
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
              IconButton(
                onPressed: _dismissSheet,
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
          Divider(color: AppColors.grey95),

          if (vm.stop?.bus?.isNotEmpty == true) ...[
            infoRow(
              'Latitude : ',
              vm.stop?.lat.toString() ?? 'inconnue',
              Icons.location_on,
            ),
            const SizedBox(height: 12),
            infoRow(
              'Longitude : ',
              vm.stop?.lon.toString() ?? 'inconnue',
              Icons.location_on,
            ),
            const SizedBox(height: 12),
            infoRow('Zone : ', vm.stop?.zone ?? 'inconnue', Icons.map),
            Divider(color: AppColors.grey95, height: 24),

            // bus
            Text(
              'Bus passant par cet arrêt : ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vm.stop!.bus!.map((bus) {
                return AppActionChip(
                  label: Text(
                    bus.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryShade100,
                    ),
                  ),
                  onPressed: () => widget.onBusTap(bus),
                );
              }).toList(),
            ),
          ] else ...[
            const Text(
              'Nous n\'avons pas pu récupérer les informations concernant cet arrêt.',
            ),
            const SizedBox(height: 8),
            const Text('Veuillez vérifier votre connexion internet.'),
          ],
        ],
      ),
    );
  }

  Widget infoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.secondaryMain),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
