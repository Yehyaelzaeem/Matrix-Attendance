import 'package:equatable/equatable.dart';

import '../utils/json_reader.dart';

class Paginated<T> extends Equatable {
  const Paginated({
    required this.items,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.loadingMore = false,
  });

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool loadingMore;

  bool get hasMore => currentPage < lastPage;

  bool get isEmpty => items.isEmpty;

  int get nextPage => currentPage + 1;

  factory Paginated.fromData(
    Map<String, dynamic> data,
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final items = JsonReader.list(data[key]).map(fromJson).toList();
    final meta = JsonReader.mapOrNull(data['meta']);
    return Paginated(
      items: items,
      currentPage: JsonReader.toInt(meta?['current_page'], 1),
      lastPage: JsonReader.toInt(meta?['last_page'], 1),
      total: JsonReader.toInt(meta?['total'], items.length),
    );
  }

  Paginated<T> append(Paginated<T> next) => Paginated(
        items: [...items, ...next.items],
        currentPage: next.currentPage,
        lastPage: next.lastPage,
        total: next.total,
      );

  Paginated<T> copyWith({List<T>? items, bool? loadingMore, int? total}) =>
      Paginated(
        items: items ?? this.items,
        currentPage: currentPage,
        lastPage: lastPage,
        total: total ?? this.total,
        loadingMore: loadingMore ?? this.loadingMore,
      );

  Paginated<T> replace(bool Function(T item) test, T updated) =>
      copyWith(items: [for (final i in items) test(i) ? updated : i]);

  Paginated<T> remove(bool Function(T item) test) => copyWith(
      items: items.where((i) => !test(i)).toList(),
      total: total > 0 ? total - 1 : 0);

  Paginated<T> prepend(T item) =>
      copyWith(items: [item, ...items], total: total + 1);

  @override
  List<Object?> get props => [items, currentPage, lastPage, total, loadingMore];
}
