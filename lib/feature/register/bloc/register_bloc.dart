import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/core/error/excetpions/exceptions.dart';
import 'package:flutter_dreamscape/data/auth/models/models.dart';
import 'package:flutter_dreamscape/domain/repository/auth_repository_abstract.dart';
import 'package:get_it/get_it.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepositoryAbstract authRepository =
      GetIt.I<AuthRepositoryAbstract>();
  RegisterBloc() : super(RegisterFormState()) {
    on<RegisterRequest>((event, emit) async {
      emit(RegisterLoadInProgress());
      final user = await authRepository.register(
          username: event.username,
          password: event.password,
          email: event.email);

      user.fold(
          (error) => {
                emit(RegisterLoadFailure(
                  FormGeneralException(message: 'Unidentified error'),
                ))
              },
          (data) => {emit(RegisterLoadSuccess(data))});
    });
  }
}
