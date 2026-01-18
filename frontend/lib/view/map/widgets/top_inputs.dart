import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/router/routes.dart';
import 'package:frontend/widgets/app_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TopInputs extends StatelessWidget {
  final Function() onBackTap;
  final TextEditingController startController;
  final TextEditingController destController;

  const TopInputs({
    super.key,
    required this.onBackTap,
    required this.startController,
    required this.destController,
  });

  @override
  Widget build(BuildContext context) {
    return // inputs on top
    IntrinsicHeight(
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
              child: BackButton(onPressed: () => onBackTap()),
            ),

            Expanded(
              child: Stack(
                children: [
                  Column(
                    spacing: 8,
                    children: [
                      SizedBox(height: 1),
                      AppTextField(
                        controller: startController,
                        hintText: 'Point de départ',
                        icon: Icons.circle_outlined,
                        onTap: () => context.goNamed(Routes.home.path),
                      ),
                      AppTextField(
                        controller: destController,
                        hintText: 'Destination',
                        icon: Symbols.distance,
                        onTap: () => context.goNamed(Routes.home.path),
                      ),
                    ],
                  ),

                  /*

                          Align(
                            alignment: Alignment.centerRight,
                            heightFactor: 2.5,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(8),
                                backgroundColor: AppColors.primaryMain,
                              ),
                              child: Icon(
                                Symbols.swap_vert,
                                opticalSize: 24,
                                color: AppColors.secondaryShade100,
                              ),
                            ),
                          ),

                        */
                ],
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
