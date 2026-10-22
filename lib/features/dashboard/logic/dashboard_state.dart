part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.admin,
    this.reviewer,
    this.followUp = const [],
    this.loading = false,
    this.error,
  });

  final AdminDashboard? admin;
  final ReviewerDashboard? reviewer;
  final List<ReportPerson> followUp;
  final bool loading;
  final String? error;

  DashboardState copyWith({
    AdminDashboard? admin,
    ReviewerDashboard? reviewer,
    List<ReportPerson>? followUp,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      DashboardState(
        admin: admin ?? this.admin,
        reviewer: reviewer ?? this.reviewer,
        followUp: followUp ?? this.followUp,
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [admin, reviewer, followUp, loading, error];
}
