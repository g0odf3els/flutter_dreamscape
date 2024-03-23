import 'dart:async';
import 'dart:convert';
import 'package:flutter_dreamscape/repositories/url_helper.dart';
import 'package:flutter_dreamscape/repositories/user/models/models.dart';
import 'package:flutter_dreamscape/repositories/user/user_repository_abstract.dart';
import 'package:http/http.dart' as http;

class UserRepository implements UserRepostiryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<User> getUser(String id) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/users/$id');

    final response =
        await http.get(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse);
    }

    throw Exception();
  }
}
