import 'package:flutter/material.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/view/on_boarding/widgets/on_boarding_slider_page.dart';
import 'package:frontend/view/on_boarding/widgets/page_slider.dart';
import 'package:frontend/viewmodel/on_boarding_viewmodel.dart';

class OnBoardingView extends StatelessWidget {
  final Function(BuildContext) onConfirmPress;

  const OnBoardingView({super.key, required this.onConfirmPress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageSlider(
          prevBtnLabel: 'Préc.',
          nextBtnLabel: 'Suivant',
          finalBtnLabel: "C'est parti !",
          onConfirmPress: (context) => onConfirmPress(context),
          pages: [
            OnBoardingSliderPage(
              title: "Bienvenue sur BeTax ",
              description:
                  "Planifiez vos trajets en bus en quelques secondes "
                  "et découvrez comment vous déplacer facilement dans tout Tanà.",
              svgAssetName: AppIllustrations.welcome,
            ),
            OnBoardingSliderPage(
              title: "Trouvez votre itinéraire",
              description:
                  "Indiquez votre point de départ et votre destination, "
                  "BeTax vous proposera les meilleurs bus à prendre.",
              svgAssetName: AppIllustrations.itinerary,
            ),
            OnBoardingSliderPage(
              title: "Faites des économies",
              description:
                  "BeTax optimise vos trajets "
                  "pour dépenser moins et arriver plus vite.",
              svgAssetName: AppIllustrations.economy,
            ),
          ],
        ),
      ),
    );
  }
}
