import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/data/auth/models/models.dart';
import 'package:flutter_dreamscape/domain/repository/auth_repository_abstract.dart';
import 'package:get_it/get_it.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryAbstract authRepository =
      GetIt.I<AuthRepositoryAbstract>();

  AuthBloc() : super(AuthLoadingState()) {
    on<AuthAuthenticateEvent>((event, emit) async {
      emit(AuthAuthenticatedState(user: event.user));
    });

    on<AuthLogoutEvent>((event, emit) async {
      authRepository.logout();
      emit(AuthUnauthenticatedState());
    });

    on<AuthLoadUserEvent>((event, emit) async {
      emit(AuthLoadingState());
      final user = await authRepository.loadUser();

      user.fold((error) => {emit(AuthUnauthenticatedState())},
          (data) => {emit(AuthAuthenticatedState(user: data))});
    });

    add(AuthLoadUserEvent());
  }
}
