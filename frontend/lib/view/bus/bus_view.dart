import 'package:flutter/material.dart';
import 'package:frontend/constants/app_text_styles.dart';
import 'package:frontend/router/routes.dart';
import 'package:go_router/go_router.dart';

class BusView extends StatelessWidget {
  const BusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('En cours de développement :(', style: AppTextStyles.bodyLarge),
        ElevatedButton(
          onPressed: () => context.goNamed(Routes.home.path),
          child: Text("Revenir à l'accueil"),
        ),
      ],
    );
  }
}
