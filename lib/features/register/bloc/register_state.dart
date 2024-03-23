part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterFormState extends RegisterState {}

class RegisterLoadInProgress extends RegisterState {}

class RegisterLoadSuccess extends RegisterState {
  final AuthData user;

  const RegisterLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class RegisterLoadFailure extends RegisterState {
  final Exception exception;

  const RegisterLoadFailure(this.exception);

  @override
  List<Object> get props => [exception];
}
