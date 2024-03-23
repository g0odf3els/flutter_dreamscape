import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/repositories/auth/auth.dart';
import 'package:flutter_dreamscape/repositories/auth/exceptions/exceptions.dart';
import 'package:flutter_dreamscape/repositories/auth/models/models.dart';
import 'package:get_it/get_it.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepositoryAbstract authRepository =
      GetIt.I<AuthRepositoryAbstract>();
  LoginBloc() : super(LoginFormState()) {
    on<LoginRequest>((event, emit) async {
      emit(LoginLoadInProgress());
      try {
        final user = await authRepository.login(
          username: event.username,
          password: event.password,
        );
        emit(LoginLoadSuccess(
          user,
        ));
      } on FormGeneralException catch (e) {
        emit(LoginLoadFailure(e));
      } on FormFieldsException catch (e) {
        emit(LoginLoadFailure(e));
      } catch (e) {
        emit(LoginLoadFailure(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
  }
}
