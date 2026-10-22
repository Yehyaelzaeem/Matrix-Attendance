import 'package:app_base/core/widgets/app_empty.dart';
import 'package:app_base/core/widgets/custom_loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/locale_keys.dart';

class CustomPaginationListView<T> extends StatefulWidget {
  final Future<void> Function()? _onLoadMore;
  final bool _isLoading;
  final bool _isMoreLoading;
  final List<Widget>? _slivers;
  final int _itemCount;
  final bool _hasMorePages;
  final ScrollController? _controller;
  final Future<void> Function()? _onRefresh;
  final NullableIndexedWidgetBuilder _builder;
  final Axis? _scrollDirection;
  final ScrollPhysics? _physics;
  final EdgeInsetsGeometry? _padding;
  final double _spacing;
  final String? _emptyMessage;
  final Widget? _emptyWidget;

  @override
  State<CustomPaginationListView<T>> createState() =>
      _CustomPaginationListViewState<T>();

  const CustomPaginationListView({
    super.key,
    Future<void> Function()? onLoadMore,
    bool isMoreLoading = false,
    bool isLoading = false,
    List<Widget>? slivers,
    required int itemCount,
    Future<void> Function()? onRefresh,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool hasMorePages = false,
    Axis? scrollDirection,
    EdgeInsetsGeometry? padding,
    double spacing = 10,
    String? emptyMessage,
    Widget? emptyWidget,
    required NullableIndexedWidgetBuilder builder,
  })  : _onLoadMore = onLoadMore,
        _isMoreLoading = isMoreLoading,
        _isLoading = isLoading,
        _physics = physics,
        _controller = controller,
        _scrollDirection = scrollDirection,
        _slivers = slivers,
        _itemCount = itemCount,
        _onRefresh = onRefresh,
        _hasMorePages = hasMorePages,
        _padding = padding,
        _spacing = spacing,
        _emptyMessage = emptyMessage,
        _emptyWidget = emptyWidget,
        _builder = builder;
}

class _CustomPaginationListViewState<T>
    extends State<CustomPaginationListView<T>> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (widget._controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget._controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
    _scheduleFillCheck();
  }

  @override
  void didUpdateWidget(covariant CustomPaginationListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._itemCount != widget._itemCount ||
        oldWidget._hasMorePages != widget._hasMorePages) {
      _scheduleFillCheck();
    }
  }

  void _scheduleFillCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final position = _scrollController.position;
      if (!position.hasContentDimensions) return;
      if (position.maxScrollExtent <= 0) _loadMore();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.outOfRange) return;
    if (position.userScrollDirection != ScrollDirection.reverse) return;
    const endReachedOffset = 200.0;
    if (position.pixels >= position.maxScrollExtent - endReachedOffset) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final onLoadMore = widget._onLoadMore;
    if (onLoadMore == null ||
        _isLoadingMore ||
        widget._isMoreLoading ||
        !widget._hasMorePages ||
        widget._isLoading) {
      return;
    }
    setState(() => _isLoadingMore = true);
    try {
      await onLoadMore();
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      scrollDirection: widget._scrollDirection ?? Axis.vertical,
      physics: widget._physics ?? const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        if (widget._slivers != null) ...widget._slivers!,
        if (widget._isLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CustomLoadingWidget()),
          )
        else if (widget._itemCount == 0)
          SliverFillRemaining(
            hasScrollBody: false,
            child: widget._emptyWidget ??
                AppEmpty(
                    message:
                        widget._emptyMessage ?? LocaleKeys.error_notFound.tr()),
          )
        else
          SliverPadding(
            padding: widget._padding ?? EdgeInsets.zero,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(
                      bottom: index == widget._itemCount - 1
                          ? 0
                          : widget._spacing.h),
                  child:
                      RepaintBoundary(child: widget._builder(context, index)),
                ),
                childCount: widget._itemCount,
                addRepaintBoundaries: false,
              ),
            ),
          ),
        if (!widget._isLoading && (widget._isMoreLoading || _isLoadingMore))
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CustomLoadingWidget(size: 20)),
            ),
          ),
      ],
    );

    if (widget._onRefresh != null) {
      return RefreshIndicator(onRefresh: widget._onRefresh!, child: scrollView);
    }
    return scrollView;
  }
}
