import 'dart:io';
import 'package:flutter_dreamscape/repositories/collection/collection_repository.dart';
import 'package:flutter_dreamscape/repositories/collection/collection_repository_abstract.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/app.dart';
import 'package:flutter_dreamscape/repositories/auth/auth.dart';
import 'package:flutter_dreamscape/repositories/user/user.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';

void main() {
  GetIt.I.registerLazySingleton<UserRepostiryAbstract>(() => UserRepository());

  GetIt.I
      .registerLazySingleton<ImageRepositoryAbstract>(() => ImageRepository());

  GetIt.I.registerLazySingleton<CollectionRepositoryAbstract>(
      () => CollectionRepository());

  GetIt.I.registerLazySingleton<AuthRepositoryAbstract>(() => AuthRepository());

  HttpOverrides.global = MyHttpOverrides();

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
