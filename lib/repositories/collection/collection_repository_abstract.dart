import 'package:flutter_dreamscape/repositories/collection/models/models.dart';

abstract class CollectionRepositoryAbstract {
  Future<CollectionPagedList> getCollectionList(
      {required GetCollectionListParams params});

  Future<CollectionPagedList> getUserCollectionList(
      {required GetCollectionListParams params, required String accessToken});

  Future<void> appendFileToCollection(
      {required String collectionId,
      required String fileId,
      required String accessToken});

  Future<void> removeFileFromCollection(
      {required String collectionId,
      required String fileId,
      required String accessToken});
}
