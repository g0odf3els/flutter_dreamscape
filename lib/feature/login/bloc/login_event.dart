part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginRequest extends LoginEvent {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
