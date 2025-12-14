import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingSliderPage extends StatelessWidget {
  final String svgAssetName, title, description;

  const OnBoardingSliderPage({
    super.key,
    required this.svgAssetName,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 36),
          SizedBox(
            height: 110,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          SizedBox(
            height: 110,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(svgAssetName, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
