import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/data/auth/models/models.dart';
import 'package:flutter_dreamscape/data/secure_storage/secure_storage.dart';
import 'package:flutter_dreamscape/config/base_url_config.dart';
import 'package:flutter_dreamscape/domain/repository/auth_repository_abstract.dart';
import 'package:http/http.dart' as http;

class AuthRepository implements AuthRepositoryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<Either<Failure, AuthData>> login(
      {required String username, required String password}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/Authorization/Login',
        {'username': username, 'password': password});

    Completer<Either<Failure, AuthData>> completer = Completer();

    try {
      final response = await http.post(url).timeout(const Duration(seconds: 2),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final user = AuthData.fromJson(jsonDecode(response.body));
        saveUser(user);
        completer.complete(Right(user));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }
    return completer.future;
  }

  @override
  Future<Either<Failure, AuthData>> register(
      {required String email,
      required String username,
      required String password}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/Authorization/Register',
        {'email': email, 'username': username, 'password': password});

    Completer<Either<Failure, AuthData>> completer = Completer();

    try {
      final response = await http.post(url).timeout(const Duration(seconds: 2),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final user = AuthData.fromJson(jsonDecode(response.body));
        saveUser(user);
        completer.complete(Right(user));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }

    return completer.future;
  }

  @override
  Future<void> refreshToken(AuthData user) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await SecureStorageRepository.storage.delete(
      key: SecureStorageRepository.userKey,
    );
  }

  @override
  Future<Either<Failure, AuthData>> loadUser() async {
    final json = await SecureStorageRepository.storage.read(
      key: SecureStorageRepository.userKey,
    );
    try {
      if (json != null) {
        return Right(AuthData.fromJson(jsonDecode(json)));
      } else {
        return Left(StorageFailure('User not found'));
      }
    } catch (e) {
      return Left(StorageFailure('Unexpected error'));
    }
  }

  @override
  Future<void> saveUser(AuthData user) async {
    await SecureStorageRepository.storage.write(
      key: SecureStorageRepository.userKey,
      value: user.toJson(),
    );
  }
}
