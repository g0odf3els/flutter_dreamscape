part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterRequest extends RegisterEvent {
  final String email;
  final String username;
  final String password;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password];
}
