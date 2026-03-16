import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/router/routes.dart';
import 'package:frontend/view/on_boarding/widgets/on_boarding_slider_page.dart';
import 'package:go_router/go_router.dart';

class PageSlider extends StatefulWidget {
  final List<OnBoardingSliderPage> pages;
  final String nextBtnLabel, skipBtnLabel, finalBtnLabel;

  const PageSlider({
    super.key,
    required this.pages,
    required this.nextBtnLabel,
    required this.finalBtnLabel,
    required this.skipBtnLabel,
  });

  @override
  State<PageSlider> createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // prev button
          Padding(
            padding: EdgeInsets.all(8),
            child: AnimatedOpacity(
              opacity: _currentIndex == 0 ? 0 : 1,
              duration: Duration(milliseconds: 200),
              child: BackButton(onPressed: () => _prevPage(context)),
            ),
          ),

          // main content
          Expanded(
            child: PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: widget.pages,
            ),
          ),

          SizedBox(height: 32),

          // indicator of current page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(2),
                width: _currentIndex == index ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.secondaryTint100
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          SizedBox(height: 32),

          // buttons
          Padding(
            padding: const EdgeInsets.only(left: 56, right: 56, bottom: 32),
            child: Column(
              spacing: 4,
              children: [
                // next page button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _nextPage(context),
                    child: Text(
                      _currentIndex == widget.pages.length - 1
                          ? widget.finalBtnLabel
                          : widget.nextBtnLabel,
                    ),
                  ),
                ),

                // skip button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: _currentIndex == widget.pages.length - 1
                        ? null
                        : () => _skip(context),
                    child: Text(widget.skipBtnLabel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _prevPage(BuildContext context) {
    if (_currentIndex <= 0) return;
    _controller.animateToPage(
      _currentIndex - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage(BuildContext context) {
    if (_currentIndex < widget.pages.length - 1) {
      _controller.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(Routes.home.name);
    }
  }

  void _skip(BuildContext context) {
    context.goNamed(Routes.home.name);
  }
}
