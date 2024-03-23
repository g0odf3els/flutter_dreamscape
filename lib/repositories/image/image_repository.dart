import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dreamscape/repositories/image/image.dart';
import 'package:flutter_dreamscape/repositories/url_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'models/image_paged_list.dart';

class ImageRepository implements ImageRepositoryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<ImagePagedList> getImagesList(
      {required GetImageListParams params}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/files', {
      'page': params.page.toString(),
      'pageSize': params.pageSize.toString(),
      'search': params.search,
      'resolutions': params.resolutions?.join(','),
      'aspectRatios': params.aspectRations?.join(','),
      'uploaderId': params.uploaderId,
      'collectionId': params.collectionId,
    });

    final response =
        await http.get(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ImagePagedList.fromJson(jsonResponse);
    }

    throw Exception();
  }

  @override
  Future<ImagePagedList> getSimilarImagesList(
      {required String fileId, required GetImageListParams params}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/files/$fileId/similar/');

    final response =
        await http.get(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return ImagePagedList.fromJson(jsonResponse);
  }

  @override
  Future<ImageFile> getImage(String id) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/files/$id');

    final response =
        await http.get(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      return ImageFile.fromJson(jsonResponse);
    }

    throw Exception();
  }

  @override
  Future<void> uploadImage(File file, String accessToken) async {
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
      return;
    }

    throw Exception();
  }

  @override
  Future<void> deleteImage(File file, String accessToken) {
    throw UnimplementedError();
  }
}
