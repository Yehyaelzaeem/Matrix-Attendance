part of 'attendance_cubit.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

final class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

final class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

final class AttendanceSuccess extends AttendanceState {
  final AttendanceOverview overview;
  const AttendanceSuccess(this.overview);

  @override
  List<Object?> get props => [overview];
}

final class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
