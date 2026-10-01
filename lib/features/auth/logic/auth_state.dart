part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthOtpSent extends AuthState {
  final String phone;
  final bool isRegister;
  final int attempt;
  const AuthOtpSent(this.phone, {required this.isRegister, this.attempt = 0});

  @override
  List<Object?> get props => [phone, isRegister, attempt];
}

final class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
