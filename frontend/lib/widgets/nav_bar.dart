import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/constants/app_text_styles.dart';
import 'package:material_symbols_icons/symbols.dart';

class NavDestination extends StatelessWidget {
  final String label;
  final IconData icon;

  const NavDestination({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(icon, opticalSize: 24, color: AppColors.secondaryMain),
      selectedIcon: Icon(
        icon,
        opticalSize: 24,
        color: AppColors.secondaryMain,
        fill: 1,
      ),
      label: label,
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 3,
      shadowColor: AppColors.secondaryMain,
      backgroundColor: AppColors.primaryTint100,
      indicatorColor: AppColors.primaryTint50,
      overlayColor: WidgetStatePropertyAll(AppColors.primaryTint50),
      animationDuration: Duration(milliseconds: 200),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelTextStyle: WidgetStatePropertyAll(
        AppTextStyles.label.copyWith(color: AppColors.secondaryMain),
      ),
      destinations: const [
        NavDestination(label: 'Accueil', icon: Symbols.home),
        NavDestination(label: 'Carte', icon: Symbols.map),
        NavDestination(label: 'Bus', icon: Symbols.directions_bus),
      ],
    );
  }
}
