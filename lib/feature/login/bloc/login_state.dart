part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginFormState extends LoginState {}

class LoginLoadInProgress extends LoginState {}

class LoginLoadSuccess extends LoginState {
  final AuthData user;

  const LoginLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class LoginLoadFailure extends LoginState {
  final Exception exception;

  const LoginLoadFailure(this.exception);

  @override
  List<Object> get props => [exception];
}
