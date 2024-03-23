import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/repositories/auth/auth.dart';
import 'package:flutter_dreamscape/repositories/auth/models/models.dart';
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
      try {
        AuthData user = await authRepository.loadUser();
        emit(AuthAuthenticatedState(user: user));
      } catch (e) {
        emit(AuthUnauthenticatedState());
      }
    });

    add(AuthLoadUserEvent());
  }
}
