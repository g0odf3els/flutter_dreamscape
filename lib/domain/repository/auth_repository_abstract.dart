import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';

import '../../data/auth/models/user.dart';

abstract class AuthRepositoryAbstract {
  Future<Either<Failure, AuthData>> login({
    required String username,
    required String password,
  });
  Future<Either<Failure, AuthData>> register({
    required String email,
    required String username,
    required String password,
  });
  Future<void> refreshToken(AuthData user);
  Future<void> logout();
  Future<Either<Failure, AuthData>> loadUser();
  Future<void> saveUser(AuthData user);
}
