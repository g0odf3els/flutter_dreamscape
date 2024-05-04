import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/core/error/excetpions/exceptions.dart';
import 'package:flutter_dreamscape/data/auth/models/models.dart';
import 'package:flutter_dreamscape/domain/repository/auth_repository_abstract.dart';
import 'package:get_it/get_it.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepositoryAbstract authRepository =
      GetIt.I<AuthRepositoryAbstract>();
  LoginBloc() : super(LoginFormState()) {
    on<LoginRequest>((event, emit) async {
      emit(LoginLoadInProgress());
      final user = await authRepository.login(
        username: event.username,
        password: event.password,
      );

      user.fold(
          (error) => {
                emit(LoginLoadFailure(
                  FormGeneralException(message: 'Unidentified error'),
                ))
              },
          (data) => {emit(LoginLoadSuccess(data))});
    });
  }
}
