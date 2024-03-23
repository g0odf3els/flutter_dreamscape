class HelperService {
  static const String host = "10.0.3.2";
  static const int port = 7134;
  static const String scheme = "https";
  static const String apiPath = "/api/";

  static Uri buildUri(String path, [Map<String, dynamic>? params]) {
    var uri = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: apiPath + path,
    );

    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }

    return uri;
  }

  static Map<String, String> buildHeaders({String? accessToken}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}
