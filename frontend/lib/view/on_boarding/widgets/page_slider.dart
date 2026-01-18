import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/view/on_boarding/widgets/on_boarding_slider_page.dart';

class PageSlider extends StatefulWidget {
  final List<OnBoardingSliderPage> pages;
  final Function(BuildContext) onConfirmPress;
  final String nextBtnLabel, prevBtnLabel, finalBtnLabel;

  const PageSlider({
    super.key,
    required this.pages,
    required this.onConfirmPress,
    required this.nextBtnLabel,
    required this.finalBtnLabel,
    required this.prevBtnLabel,
  });

  @override
  State<PageSlider> createState() => _PageSliderState();
}

class _PageSliderState extends State<PageSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // main content
        SizedBox(
          height: 600,
          width: double.infinity,
          child: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: widget.pages,
          ),
        ),

        Spacer(),

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
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 4,
            children: [
              // prev page button
              IgnorePointer(
                ignoring: _currentIndex < 0,
                child: AnimatedOpacity(
                  opacity: _currentIndex > 0 ? 1 : 0,
                  duration: const Duration(milliseconds: 350),
                  child: ElevatedButton(
                    onPressed: () => _prevPage(context),
                    child: Text(widget.prevBtnLabel),
                  ),
                ),
              ),

              // next page button
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedSize(
                  duration: Duration(milliseconds: 100),
                  child: ElevatedButton(
                    onPressed: () => _nextPage(context),
                    style: ButtonStyle(
                      foregroundColor: _currentIndex == widget.pages.length - 1
                          ? WidgetStatePropertyAll(AppColors.secondaryShade100)
                          : WidgetStatePropertyAll(AppColors.primaryTint100),
                      backgroundColor: _currentIndex == widget.pages.length - 1
                          ? WidgetStatePropertyAll(AppColors.primaryMain)
                          : WidgetStatePropertyAll(AppColors.secondaryMain),
                    ),
                    child: Text(
                      _currentIndex == widget.pages.length - 1
                          ? widget.finalBtnLabel
                          : widget.nextBtnLabel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
      widget.onConfirmPress(context);
    }
  }
}
