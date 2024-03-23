import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dreamscape/repositories/auth/exceptions/exceptions.dart';
import 'package:flutter_dreamscape/repositories/auth/helper_service.dart';
import 'package:flutter_dreamscape/repositories/auth/models/models.dart';
import 'package:flutter_dreamscape/repositories/secure_storage/secure_storage.dart';
import 'package:flutter_dreamscape/repositories/auth/auth_repository_abstract.dart';
import 'package:flutter_dreamscape/repositories/url_helper.dart';

class AuthRepository implements AuthRepositoryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<AuthData> login(
      {required String username, required String password}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/Authorization/Login',
        {'username': username, 'password': password});

    final response =
        await http.post(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final user = AuthData.fromJson(jsonDecode(response.body));
      saveUser(user);
      return user;
    }

    throw FormGeneralException(message: 'Error contacting the server!');
  }

  @override
  Future<AuthData> register(
      {required String email,
      required String username,
      required String password}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/Authorization/Register',
        {'email': email, 'username': username, 'password': password});

    final response =
        await http.post(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final user = AuthData.fromJson(jsonDecode(response.body));
      saveUser(user);
      return user;
    }

    throw FormGeneralException(message: 'Error contacting the server!');
  }

  @override
  Future<void> refreshToken(AuthData user) async {
    final response = await http.post(
      HelperService.buildUri('/api/Authorization/Refresh'),
      headers: HelperService.buildHeaders(),
      body: jsonEncode(
        {'accessToken': user.accessToken, 'refreshToken': user.refreshToken},
      ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      user.accessToken = json['access'];
      saveUser(user);
    }

    throw FormGeneralException(message: 'Error contacting the server!');
  }

  @override
  Future<void> logout() async {
    await SecureStorageRepository.storage.delete(
      key: SecureStorageRepository.userKey,
    );
  }

  @override
  Future<AuthData> loadUser() async {
    final json = await SecureStorageRepository.storage.read(
      key: SecureStorageRepository.userKey,
    );
    if (json != null) {
      return AuthData.fromJson(jsonDecode(json));
    } else {
      throw SecureStorageNotFoundException();
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
