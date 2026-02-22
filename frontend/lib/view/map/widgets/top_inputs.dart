import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TopInputs extends StatefulWidget {
  final Function() onBackTap;
  final Function() onSearchTap;
  final Function() onSwapPress;
  final TextEditingController startController;
  final TextEditingController destController;
  final Function() onStartTap;
  final Function() onEndTap;

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

class _TopInputsState extends State<TopInputs> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        color: AppColors.primaryTint100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: kToolbarHeight,
              child: BackButton(onPressed: () => widget.onBackTap()),
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    Column(
                      spacing: 8,
                      children: [
                        SizedBox(height: 1),
                        AppTextField(
                          validator: null,
                          controller: widget.startController,
                          hintText: 'Point de départ',
                          icon: Icons.circle_outlined,
                          onTap: () => widget.onStartTap(),
                        ),
                        AppTextField(
                          validator: null,
                          controller: widget.destController,
                          hintText: 'Destination',
                          icon: Symbols.distance,
                          onTap: () => widget.onEndTap(),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.secondaryMain,
                              backgroundColor: AppColors.primaryMain,
                            ),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) return;
                              widget.onSearchTap();
                            },
                            child: Text('Rechercher'),
                          ),
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      heightFactor: 2.5,
                      child: ElevatedButton(
                        onPressed: widget.onSwapPress,
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.componentBg,
                            width: 2,
                          ),
                          shape: CircleBorder(),
                          backgroundColor: AppColors.primaryMain,
                        ),
                        child: Icon(
                          Icons.swap_vert,
                          fontWeight: FontWeight.bold,
                          opticalSize: 24,
                          color: AppColors.secondaryShade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
