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
  final List<HolidayModel> holidays;
  const TeamSuccess({required this.employees, required this.holidays});

  EmployeeModel? byName(String name) {
    for (final e in employees) {
      if (e.name == name) return e;
    }
    return null;
  }

  @override
  List<Object?> get props => [employees, holidays];
}

final class TeamError extends TeamState {
  final String message;
  const TeamError(this.message);

  @override
  List<Object?> get props => [message];
}
