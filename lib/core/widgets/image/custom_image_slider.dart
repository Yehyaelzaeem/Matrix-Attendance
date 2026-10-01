import 'dart:async';

import 'package:app_base/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import 'custom_image.dart';

class CustomImageSlider extends StatefulWidget {
  final List<String> _sliders;
  final ValueChanged<int>? _onTap;
  final double _height;
  final double? _width;
  final double? _imageWidth;
  final double _radius;
  final EdgeInsetsGeometry? _margin;
  final double _viewportFraction;
  final double _itemHorizontalPadding;

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();

  const CustomImageSlider({
    super.key,
    required List<String> sliders,
    ValueChanged<int>? onTap,
    double height = 199,
    double imageWidth = 199,
    double width = 199,
    EdgeInsetsGeometry? margin,
    double radius = 12,
    double viewportFraction = 0.88,
    double itemHorizontalPadding = 5,
  })  : _sliders = sliders,
        _onTap = onTap,
        _radius = radius,
        _width = width,
        _imageWidth = imageWidth,
        _margin = margin,
        _viewportFraction = viewportFraction,
        _itemHorizontalPadding = itemHorizontalPadding,
        _height = height;
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  static const Duration _autoPlayInterval = Duration(seconds: 4);
  static const Duration _pageAnimDuration = Duration(milliseconds: 420);

  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  Timer? _resumeAutoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget._viewportFraction,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _cancelAutoPlayTimers();
    _pageController.dispose();
    super.dispose();
  }

  void _cancelAutoPlayTimers() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    _resumeAutoPlayTimer?.cancel();
    _resumeAutoPlayTimer = null;
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget._sliders.length < 2) return;
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      final n = widget._sliders.length;
      final next = (_currentPage + 1) % n;
      _pageController.animateToPage(
        next,
        duration: _pageAnimDuration,
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onUserScrollStart() {
    _cancelAutoPlayTimers();
    _resumeAutoPlayTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) _startAutoPlay();
    });
  }

  Widget _bannerCard({required Widget child}) {
    final r = widget._radius.r;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: child,
      ),
    );
  }

  Widget _pageIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
          width: isActive ? 32.w : 7.w,
          height: 7.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: isActive
                ? AppColors.primaryColor.themeColor
                : AppColors.primaryColor.themeColor.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }

  Widget _scaledPage(int index, Widget child) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, _) {
        double scale = 1.0;
        if (_pageController.hasClients &&
            _pageController.position.hasContentDimensions) {
          final page = _pageController.page ?? _currentPage.toDouble();
          final dist = (page - index).abs();
          scale = (1.0 - dist * 0.1).clamp(0.9, 1.0);
        } else {
          scale = index == _currentPage ? 1.0 : 0.94;
        }
        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._sliders.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.sizeOf(context).width;
    final singleW = widget._imageWidth == double.infinity
        ? screenW
        : (widget._imageWidth ?? screenW);

    return Container(
      margin: widget._margin,
      width: widget._width ?? double.infinity,
      child: Column(
        children: [
          if (widget._sliders.length < 2)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _bannerCard(
                child: GestureDetector(
                  onTap: () => widget._onTap?.call(0),
                  child: CustomImage(
                    image: widget._sliders.first,
                    width: singleW,
                    height: widget._height,
                    fit: BoxFit.fill,
                    radius: 0,
                  ),
                ),
              ),
            )
          else ...[
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.axis != Axis.horizontal) {
                  return false;
                }
                if (notification is ScrollStartNotification) {
                  _onUserScrollStart();
                }
                return false;
              },
              child: SizedBox(
                height: widget._height,
                child: PageView.builder(
                  controller: _pageController,
                  clipBehavior: Clip.none,
                  itemCount: widget._sliders.length,
                  physics: const BouncingScrollPhysics(
                    parent: PageScrollPhysics(),
                  ),
                  onPageChanged: (i) {
                    setState(() => _currentPage = i);
                  },
                  itemBuilder: (context, index) {
                    return _scaledPage(
                      index,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget._itemHorizontalPadding.w,
                        ),
                        child: _bannerCard(
                          child: GestureDetector(
                            onTap: () => widget._onTap?.call(index),
                            child: CustomImage(
                              image: widget._sliders[index],
                              width: double.infinity,
                              height: widget._height,
                              fit: BoxFit.fill,
                              radius: 0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            14.height,
            _pageIndicators(widget._sliders.length),
          ],
        ],
      ),
    );
  }
}
