import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/data/image/models/models.dart';
import 'package:flutter_dreamscape/config/base_url_config.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageRepository implements ImageRepositoryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<Either<Failure, ImagePagedList>> getImagesList(
      {int page = 1,
      int pageSize = 16,
      String? search,
      List<String>? resolutions,
      List<String>? aspectRations,
      String? uploaderId,
      String? collectionId}) async {
    Completer<Either<Failure, ImagePagedList>> completer = Completer();

    var url = Uri.https('$_baseUrl:$_port', '/api/files', {
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      'search': search,
      'resolutions': resolutions?.join(','),
      'aspectRatios': aspectRations?.join(','),
      'uploaderId': uploaderId,
      'collectionId': collectionId,
    });

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 2),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        completer.complete(Right(ImagePagedList.fromJson(jsonResponse)));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }

    return completer.future;
  }

  @override
  Future<Either<Failure, ImagePagedList>> getSimilarImagesList(
      {required String fileId,
      int page = 1,
      int pageSize = 16,
      String? search,
      List<String>? resolutions,
      List<String>? aspectRations,
      String? uploaderId,
      String? collectionId}) async {
    Completer<Either<Failure, ImagePagedList>> completer = Completer();

    var url = Uri.https('$_baseUrl:$_port', '/api/files/$fileId/similar/');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 2),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        completer.complete(Right(ImagePagedList.fromJson(jsonResponse)));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }

    return completer.future;
  }

  @override
  Future<Either<Failure, ImageFile>> getImage(String id) async {
    Completer<Either<Failure, ImageFile>> completer = Completer();

    var url = Uri.https('$_baseUrl:$_port', '/api/files/$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15),
          onTimeout: () {
        throw TimeoutException;
      });

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        completer.complete(Right(ImageFile.fromJson(jsonResponse)));
      } else {
        completer.complete(Left(ServerFailure(response.statusCode.toString())));
      }
    } catch (e) {
      completer.complete(Left(ConnectionFailure()));
    }

    return completer.future;
  }

  @override
  Future<void> uploadImage(File file, String accessToken) async {
    Completer<void> completer = Completer();

    var url = Uri.https('$_baseUrl:$_port', '/api/files/upload');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'upload',
        file.path,
        contentType: MediaType('image', 'jpg'),
      ));

    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    var response = await request.send().timeout(const Duration(seconds: 15),
        onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      completer.complete();
    } else {
      completer.completeError(Exception());
    }

    return completer.future;
  }

  @override
  Future<void> deleteImage(File file, String accessToken) {
    throw UnimplementedError();
  }
}
