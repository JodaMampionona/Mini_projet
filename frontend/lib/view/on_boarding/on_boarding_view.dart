import 'package:flutter/material.dart';
import 'package:frontend/constants/app_assets.dart';
import 'package:frontend/view/on_boarding/widgets/on_boarding_slider_page.dart';
import 'package:frontend/view/on_boarding/widgets/page_slider.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageSlider(
        skipBtnLabel: 'Passer',
        nextBtnLabel: 'Suivant',
        finalBtnLabel: "Démarrer",
        pages: [
          OnBoardingSliderPage(
            title: "Bienvenue sur BeTax ",
            description:
                "Planifiez vos trajets en bus en quelques secondes et "
                "déplacez-vous facilement dans tout Tanà.",
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
                "pour dépenser moins d'argent et arriver plus rapidement à votre destination.",
            svgAssetName: AppIllustrations.economy,
          ),
        ],
      ),
    );
  }
}
