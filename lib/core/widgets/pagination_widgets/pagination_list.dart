import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;

class CustomPaginationListView<T> extends StatefulWidget {
  final Function _onLoadMore;
  final bool _isLoading;
  final bool _isMoreLoading;
  final List<Widget>? _slivers;
  final int _itemCount;
  final int _currentPage;
  final bool _hasMorePages;
  final ScrollController? _controller;
  final Future<void> Function()? _onRefresh;
  final NullableIndexedWidgetBuilder _builder;
  final Axis? _scrollDirection;
  final ScrollPhysics? _physics;

  @override
  _CustomPaginationListViewState createState() =>
      _CustomPaginationListViewState();

  const CustomPaginationListView({
    super.key,
    required VoidCallback onLoadMore,
    required bool isMoreLoading,
    bool isLoading = false,
    List<Widget>? slivers,
    required int itemCount,
    required int currentPage,
    Future<void> Function()? onRefresh,
    ScrollPhysics? physics,
    ScrollController? controller,
    required bool hasMorePages,
    Axis? scrollDirection,
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
        _currentPage = currentPage,
        _hasMorePages = hasMorePages,
        _builder = builder;
}

class _CustomPaginationListViewState extends State<CustomPaginationListView> {
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void dispose() {
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
  }

  void _onScroll() {
    if (_isLoadingMore || !widget._hasMorePages || widget._isLoading) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.outOfRange) return;

    if (position.userScrollDirection != ScrollDirection.reverse) return;

    const endReachedOffset = 200.0;
    final reachedNearEnd =
        position.pixels >= (position.maxScrollExtent - endReachedOffset);
    if (reachedNearEnd) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      await widget._onLoadMore();
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      scrollDirection: widget._scrollDirection ?? Axis.vertical,
      physics: widget._physics ?? const ClampingScrollPhysics(),
      controller: _scrollController,
      cacheExtent: 3000,
      slivers: [
        if (widget._slivers != null) ...widget._slivers!,
        if (widget._isLoading)
          SliverFillRemaining(
            hasScrollBody: false,
            child: const Center(child: CustomLoadingWidget()),
          )
        else if (widget._itemCount == 0)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
                child: Column(
              children: [AppText('No Data Found')],
            )),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RepaintBoundary(
                  child: widget._builder(context, index),
                );
              },
              childCount: widget._itemCount,
              addRepaintBoundaries: false,
            ),
          ),
        if (!widget._isLoading && (widget._isMoreLoading || _isLoadingMore))
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CustomLoadingWidget(size: 20),
              ),
            ),
          )
        else
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
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
