import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/repositories/auth/auth.dart';
import 'package:flutter_dreamscape/repositories/auth/exceptions/exceptions.dart';
import 'package:flutter_dreamscape/repositories/auth/models/models.dart';
import 'package:get_it/get_it.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepositoryAbstract authRepository =
      GetIt.I<AuthRepositoryAbstract>();
  RegisterBloc() : super(RegisterFormState()) {
    on<RegisterRequest>((event, emit) async {
      emit(RegisterLoadInProgress());
      try {
        final user = await authRepository.register(
          email: event.email,
          password: event.password,
          username: event.username,
        );
        emit(RegisterLoadSuccess(
          user,
        ));
      } on FormGeneralException catch (e) {
        emit(RegisterLoadFailure(e));
      } on FormFieldsException catch (e) {
        emit(RegisterLoadFailure(e));
      } catch (e) {
        emit(RegisterLoadFailure(
          FormGeneralException(message: 'Unidentified error'),
        ));
      }
    });
  }
}
