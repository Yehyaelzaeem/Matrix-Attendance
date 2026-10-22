part of 'team_cubit.dart';

sealed class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object?> get props => [];
}

final class TeamInitial extends TeamState {
  const TeamInitial();
}

final class TeamLoading extends TeamState {
  const TeamLoading();
}

final class TeamSuccess extends TeamState {
  final List<EmployeeModel> employees;
  final Paginated<HolidayModel> holidays;
  const TeamSuccess({required this.employees, required this.holidays});

  EmployeeModel? byId(int id) {
    for (final e in employees) {
      if (e.id == id) return e;
    }
    return null;
  }

  TeamSuccess copyWith({
    List<EmployeeModel>? employees,
    Paginated<HolidayModel>? holidays,
  }) =>
      TeamSuccess(
        employees: employees ?? this.employees,
        holidays: holidays ?? this.holidays,
      );

  @override
  List<Object?> get props => [employees, holidays];
}

final class TeamError extends TeamState {
  final String message;
  const TeamError(this.message);

  @override
  List<Object?> get props => [message];
}
