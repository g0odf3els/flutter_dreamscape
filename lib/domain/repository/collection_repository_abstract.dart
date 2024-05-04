import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/data/collection/models/models.dart';

import '../../core/error/failure.dart';

abstract class CollectionRepositoryAbstract {
  Future<Either<Failure, CollectionPagedList>> getCollectionList(
      {int page = 1, int pageSize = 16, String? ownerId});

  Future<Either<Failure, CollectionPagedList>> getUserCollectionList(
      {int page = 1, int pageSize = 16, required String accessToken});

  Future<Either<Failure, Collection>> appendFileToCollection(
      {required String collectionId,
      required String fileId,
      required String accessToken});

  Future<Either<Failure, Collection>> removeFileFromCollection(
      {required String collectionId,
      required String fileId,
      required String accessToken});

  Future<Either<Failure, Collection>> createCollection({
    required String name,
    String? description,
    bool? isPublic,
    List<String>? filesId,
    required String accessToken,
  });
}
