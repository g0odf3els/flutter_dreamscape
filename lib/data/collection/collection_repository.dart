import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/data/collection/models/models.dart';
import 'package:flutter_dreamscape/config/base_url_config.dart';
import 'package:flutter_dreamscape/domain/repository/collection_repository_abstract.dart';
import 'package:http/http.dart' as http;

class CollectionRepository extends CollectionRepositoryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<Either<Failure, CollectionPagedList>> getCollectionList(
      {int page = 1, int pageSize = 16, String? ownerId}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/collections', {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      'ownerId': ownerId,
    });

    Completer<Either<Failure, CollectionPagedList>> completer = Completer();

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 2),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        completer.complete(Right(CollectionPagedList.fromJson(jsonResponse)));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }
    return completer.future;
  }

  @override
  Future<Either<Failure, CollectionPagedList>> getUserCollectionList(
      {int page = 1, int pageSize = 16, required String accessToken}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/collections/my',
        {'page': page.toString(), 'pageSize': pageSize.toString()});

    Completer<Either<Failure, CollectionPagedList>> completer = Completer();

    try {
      final response = await http
          .get(url, headers: {'Authorization': 'Bearer $accessToken'}).timeout(
              const Duration(seconds: 2), onTimeout: () {
        throw TimeoutException;
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        completer.complete(Right(CollectionPagedList.fromJson(jsonResponse)));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }
    return completer.future;
  }

  @override
  Future<Either<Failure, Collection>> appendFileToCollection({
    required String collectionId,
    required String fileId,
    required String accessToken,
  }) async {
    var url = Uri.https(
      '$_baseUrl:$_port',
      '/api/collections/$collectionId/append/$fileId',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      ).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          throw TimeoutException;
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Right(Collection.fromJson(jsonResponse));
      } else {
        return Left(ServerFailure(response.statusCode.toString()));
      }
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Collection>> removeFileFromCollection({
    required String collectionId,
    required String fileId,
    required String accessToken,
  }) async {
    var url = Uri.https(
      '$_baseUrl:$_port',
      '/api/collections/$collectionId/remove/$fileId',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      ).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          throw TimeoutException;
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Right(Collection.fromJson(jsonResponse));
      } else {
        return Left(ServerFailure(response.statusCode.toString()));
      }
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Collection>> createCollection({
    required String name,
    String? description,
    bool? isPublic,
    List<String>? filesId,
    required String accessToken,
  }) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/collections/create', {
      'name': name,
      'description': description,
      'isPublic': isPublic?.toString(),
      'filesId': filesId
    });

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      ).timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          throw TimeoutException;
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return Right(Collection.fromJson(jsonResponse));
      } else {
        return Left(ServerFailure(response.statusCode.toString()));
      }
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }
}
