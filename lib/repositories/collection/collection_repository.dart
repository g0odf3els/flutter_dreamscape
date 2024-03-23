import 'dart:async';
import 'dart:convert';

import 'package:flutter_dreamscape/repositories/collection/collection_repository_abstract.dart';
import 'package:flutter_dreamscape/repositories/collection/models/collection_paged_list.dart';
import 'package:flutter_dreamscape/repositories/collection/models/get_collection_list_params.dart';
import 'package:flutter_dreamscape/repositories/url_helper.dart';
import 'package:http/http.dart' as http;

class CollectionRepository extends CollectionRepositoryAbstract {
  static const String _baseUrl = UrlHelper.baseUrl;
  static const int _port = UrlHelper.port;

  @override
  Future<CollectionPagedList> getCollectionList(
      {required GetCollectionListParams params}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/collections', {
      'page': params.page.toString(),
      'pageSize': params.pageSize.toString(),
      'ownerId': params.ownerId,
    });

    final response =
        await http.get(url).timeout(const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return CollectionPagedList.fromJson(jsonResponse);
    }

    throw Exception();
  }

  @override
  Future<CollectionPagedList> getUserCollectionList(
      {required GetCollectionListParams params,
      required String accessToken}) async {
    var url = Uri.https('$_baseUrl:$_port', '/api/collections/my', {
      'page': params.page.toString(),
      'pageSize': params.pageSize.toString()
    });

    final response = await http
        .get(url, headers: {'Authorization': 'Bearer $accessToken'}).timeout(
            const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return CollectionPagedList.fromJson(jsonResponse);
    }

    throw Exception();
  }

  @override
  Future<void> appendFileToCollection(
      {required String collectionId,
      required String fileId,
      required String accessToken}) async {
    var url = Uri.https(
        '$_baseUrl:$_port', '/api/collections/$collectionId/append/$fileId');

    final response = await http
        .post(url, headers: {'Authorization': 'Bearer $accessToken'}).timeout(
            const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      return;
    }

    throw Exception();
  }

  @override
  Future<void> removeFileFromCollection(
      {required String collectionId,
      required String fileId,
      required String accessToken}) async {
    var url = Uri.https(
        '$_baseUrl:$_port', '/api/collections/$collectionId/remove/$fileId');

    final response = await http
        .post(url, headers: {'Authorization': 'Bearer $accessToken'}).timeout(
            const Duration(seconds: 2), onTimeout: () {
      throw TimeoutException;
    });

    if (response.statusCode == 200) {
      return;
    }

    throw Exception();
  }
}
