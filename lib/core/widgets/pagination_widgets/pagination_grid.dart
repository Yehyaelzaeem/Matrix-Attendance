import 'package:app_base/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_text.dart';

class CustomPaginationGridview<T> extends StatefulWidget {
  final Function _onLoadMore;

  final bool _isLoading;
  final bool _isMoreLoading;
  final List<Widget>? _slivers;
  final int _itemCount;
  final bool _hasMorePages;
  final NullableIndexedWidgetBuilder _builder;
  final Future<void> Function()? _onRefresh;
  final ScrollPhysics? _physics;
  final EdgeInsetsGeometry? _padding;
  final SliverGridDelegate? _gridDelegate;
  final double _height;
  final double _width;
  final double _crossAxisSpacing;
  final double _mainAxisSpacing;

  @override
  State<CustomPaginationGridview<T>> createState() =>
      _CustomPaginationGridviewState<T>();

  const CustomPaginationGridview({
    super.key,
    required VoidCallback onLoadMore,
    required bool isMoreLoading,
    bool isLoading = false,
    List<Widget>? slivers,
    required int? itemCount,
    required int currentPage,
    required bool hasMorePages,
    required NullableIndexedWidgetBuilder builder,
    Future<void> Function()? onRefresh,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    SliverGridDelegate? gridDelegate,
    double height = 172,
    double width = 172,
    double crossAxisSpacing = 12,
    double mainAxisSpacing = 12,
  })  : _onLoadMore = onLoadMore,
        _isLoading = isLoading,
        _isMoreLoading = isMoreLoading,
        _slivers = slivers,
        _itemCount = itemCount ?? 0,
        _hasMorePages = hasMorePages,
        _builder = builder,
        _onRefresh = onRefresh,
        _physics = physics,
        _padding = padding,
        _gridDelegate = gridDelegate,
        _height = height,
        _width = width,
        _crossAxisSpacing = crossAxisSpacing,
        _mainAxisSpacing = mainAxisSpacing;
}

class _CustomPaginationGridviewState<T>
    extends State<CustomPaginationGridview<T>> {
  final ScrollController _scrollController = ScrollController();

  bool _canLoadMore = true;
  bool _isLoadingMore = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoadingMore || widget._isMoreLoading) return;

    if (!widget._hasMorePages) return;

    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }

    if (widget._isLoading) return;

    if (!_canLoadMore) return;

    _isLoadingMore = true;
    _canLoadMore = false;

    widget._onLoadMore();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _canLoadMore = true;
          _isLoadingMore = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomPaginationGridview<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._isMoreLoading && !widget._isMoreLoading) {
      _isLoadingMore = false;
      _canLoadMore = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = RawScrollbar(
      thumbColor: Theme.of(context).primaryColor,
      radius: const Radius.circular(8),
      controller: _scrollController,
      thickness: 8,
      thumbVisibility: true,
      trackVisibility: true,
      child: CustomScrollView(
        controller: _scrollController,
        physics: widget._physics ?? const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (widget._slivers != null) ...widget._slivers!,
          if (widget._isLoading) ...[
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: true,
              leadingWidth: 0,
              elevation: 0.0,
              leading: const SizedBox(),
              expandedHeight: 100.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: const CustomLoadingWidget(),
            ),
          ] else if (widget._itemCount == 0) ...[
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: true,
              leadingWidth: 0,
              elevation: 0.0,
              leading: const SizedBox(),
              expandedHeight: 300.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                    child: Column(
                  children: [AppText('No Data Found')],
                )),
              ),
            ),
          ] else ...[
            SliverPadding(
              padding: widget._padding ?? EdgeInsets.zero,
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(widget._builder,
                    childCount: widget._itemCount),
                gridDelegate: widget._gridDelegate ??
                    SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: widget._width.w,
                      mainAxisSpacing: widget._mainAxisSpacing,
                      childAspectRatio: 10,
                      crossAxisSpacing: widget._crossAxisSpacing,
                      mainAxisExtent: widget._height.h,
                    ),
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: Center(
                child: !widget._isLoading && widget._isMoreLoading
                    ? const CustomLoadingWidget(
                        size: 20,
                      )
                    : const SizedBox(height: 40.0),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget._onRefresh != null) {
      return RefreshIndicator(
        onRefresh: widget._onRefresh!,
        child: scrollView,
      );
    }

    return scrollView;
  }
}
