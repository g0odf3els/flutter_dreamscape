import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/app.dart';
import 'package:flutter_dreamscape/injection_container.dart' as di;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  await di.init();
  runApp(const App());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
