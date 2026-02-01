import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/view/home/widgets/icon_text_field.dart';
import 'package:frontend/viewmodel/home_viewmodel.dart';

class CardForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function() onSearchItineraryPress;
  final Function() onSwapPress;
  final Function() onStartTap;
  final Function() onDestTap;
  final HomeViewModel vm;

  const CardForm({
    super.key,
    required this.formKey,
    required this.onSearchItineraryPress,
    required this.onSwapPress,
    required this.onStartTap,
    required this.onDestTap,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      margin: EdgeInsetsGeometry.zero,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // textfield start
              IconTextField(
                onTap: onStartTap,
                isReadOnly: true,
                controller: vm.startController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer un point de départ';
                  }
                  return null;
                },
                icon: Icon(
                  Icons.check_circle,
                  size: 22,
                  color: AppColors.secondaryMain,
                ),
                label: 'Point de départ',
                placeholder: 'Talatamaty',
              ),

              SizedBox(height: 6),

              // swap
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.grey95)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () => onSwapPress(),
                      icon: Icon(Icons.swap_vert),
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                          AppColors.primaryTint100,
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.secondaryMain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.grey95)),
                ],
              ),

              // textfield destination
              IconTextField(
                onTap: onDestTap,
                isReadOnly: true,
                controller: vm.destController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer une destination';
                  }
                  return null;
                },
                icon: Icon(Icons.location_on, color: AppColors.secondaryMain),
                label: 'Destination',
                placeholder: 'Andranomena',
              ),

              // button
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.primaryMain,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      AppColors.secondaryShade100,
                    ),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    onSearchItineraryPress();
                  },
                  child: Text('Rechercher'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
