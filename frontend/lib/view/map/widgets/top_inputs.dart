import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TopInputs extends StatefulWidget {
  final VoidCallback onBackTap;
  final VoidCallback onSearchTap;
  final VoidCallback onSwapPress;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  final TextEditingController startController;
  final TextEditingController destController;

  const TopInputs({
    super.key,
    required this.onBackTap,
    required this.startController,
    required this.destController,
    required this.onSwapPress,
    required this.onSearchTap,
    required this.onStartTap,
    required this.onEndTap,
  });

  @override
  State<TopInputs> createState() => _TopInputsState();
}

class _TopInputsState extends State<TopInputs> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late AnimationController _startControllerAnim;
  late AnimationController _destControllerAnim;

  late Animation<double> _startShake;
  late Animation<double> _destShake;

  @override
  void initState() {
    super.initState();

    _startControllerAnim = _createController();
    _destControllerAnim = _createController();

    _startShake = _createShake(_startControllerAnim);
    _destShake = _createShake(_destControllerAnim);
  }

  AnimationController _createController() {
    return AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  Animation<double> _createShake(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }

  void _triggerStartShake() {
    HapticFeedback.mediumImpact();
    _startControllerAnim.forward(from: 0);
  }

  void _triggerDestShake() {
    HapticFeedback.mediumImpact();
    _destControllerAnim.forward(from: 0);
  }

  @override
  void dispose() {
    _startControllerAnim.dispose();
    _destControllerAnim.dispose();
    super.dispose();
  }

  bool _validateFields() {
    final startEmpty = widget.startController.text.trim().isEmpty;
    final destEmpty = widget.destController.text.trim().isEmpty;

    if (startEmpty) _triggerStartShake();
    if (destEmpty) _triggerDestShake();

    return !startEmpty && !destEmpty;
  }

  void _onSearchPressed() {
    if (!_validateFields()) return;
    widget.onSearchTap();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        color: AppColors.primaryTint100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: kToolbarHeight,
              child: BackButton(onPressed: widget.onBackTap),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 2),

                      AnimatedBuilder(
                        animation: _startShake,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_startShake.value, 0),
                            child: child,
                          );
                        },
                        child: AppTextField(
                          validator: null,
                          controller: widget.startController,
                          hintText: 'Point de départ',
                          icon: Icons.circle_outlined,
                          onTap: widget.onStartTap,
                        ),
                      ),

                      const SizedBox(height: 8),

                      AnimatedBuilder(
                        animation: _destShake,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_destShake.value, 0),
                            child: child,
                          );
                        },
                        child: AppTextField(
                          validator: null,
                          controller: widget.destController,
                          hintText: 'Destination',
                          icon: Symbols.distance,
                          onTap: widget.onEndTap,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.secondaryMain,
                            backgroundColor: AppColors.primaryMain,
                          ),
                          onPressed: _onSearchPressed,
                          child: const Text('Rechercher'),
                        ),
                      ),
                    ],
                  ),

                  /// SWAP BUTTON
                  Positioned(
                    right: 0,
                    top: 28,
                    child: ElevatedButton(
                      onPressed: widget.onSwapPress,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: AppColors.primaryMain,
                        side: BorderSide(
                          color: AppColors.componentBg,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        color: AppColors.secondaryShade100,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
