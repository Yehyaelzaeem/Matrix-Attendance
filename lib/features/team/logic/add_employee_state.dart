part of 'add_employee_cubit.dart';

sealed class AddEmployeeState extends Equatable {
  const AddEmployeeState();

  @override
  List<Object?> get props => [];
}

final class AddEmployeeInitial extends AddEmployeeState {
  const AddEmployeeInitial();
}

final class AddEmployeeLoading extends AddEmployeeState {
  const AddEmployeeLoading();
}

final class AddEmployeeSuccess extends AddEmployeeState {
  final EmployeeModel employee;
  const AddEmployeeSuccess(this.employee);

  @override
  List<Object?> get props => [employee];
}

final class AddEmployeeError extends AddEmployeeState {
  final String message;
  const AddEmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
