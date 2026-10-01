import 'package:equatable/equatable.dart';

class PaginationMeta extends Equatable {
  const PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMorePages,
  });

  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMorePages;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
        currentPage: _parseInt(json['current_page']),
        lastPage: _parseInt(json['last_page']),
        perPage: _parseInt(json['per_page']),
        total: _parseInt(json['total']),
        hasMorePages: json['has_more_pages'] as bool? ?? false,
      );

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static const empty = PaginationMeta(
    currentPage: 0,
    lastPage: 0,
    perPage: 0,
    total: 0,
    hasMorePages: false,
  );

  @override
  List<Object?> get props =>
      [currentPage, lastPage, perPage, total, hasMorePages];
}

class PaginatedData<T> {
  const PaginatedData({required this.items, required this.pagination});

  final List<T> items;
  final PaginationMeta pagination;
}
