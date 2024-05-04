import 'dart:convert';

class AuthData {
  final String id;
  String username;
  String accessToken;
  String refreshToken;

  AuthData({
    required this.id,
    required this.username,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      id: json['id'],
      username: json['username'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  String toJson() {
    return jsonEncode(
      {
        'id': id,
        'username': username,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      },
    );
  }
}
