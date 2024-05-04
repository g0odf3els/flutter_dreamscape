import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/config/base_url_config.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/data/user/models/models.dart';
import 'package:flutter_dreamscape/domain/repository/user_repository_abstract.dart';
import 'package:http/http.dart' as http;

class UserRepository implements UserRepostiryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/users/$id');

    Completer<Either<Failure, User>> completer = Completer();

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 2),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        completer.complete(Right(User.fromJson(jsonResponse)));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }

    return completer.future;
  }
}
