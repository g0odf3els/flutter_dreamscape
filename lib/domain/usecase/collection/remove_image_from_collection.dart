import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/collection/models/collection.dart';
import 'package:flutter_dreamscape/domain/repository/collection_repository_abstract.dart';

class RemoveImageFromCollection
    implements UseCase<Collection, ParamsRemoveImageFromCollection> {
  final CollectionRepositoryAbstract collectionRepository;

  RemoveImageFromCollection({required this.collectionRepository});

  @override
  Future<Either<Failure, Collection>> call(
      ParamsRemoveImageFromCollection params) async {
    return await collectionRepository.removeFileFromCollection(
        collectionId: params.collectionId,
        fileId: params.fileId,
        accessToken: params.accessToken);
  }
}

class ParamsRemoveImageFromCollection extends Equatable {
  final String collectionId;
  final String fileId;
  final String accessToken;

  const ParamsRemoveImageFromCollection(
      {required this.collectionId,
      required this.fileId,
      required this.accessToken});

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'RemoveImageFromCollection{category: $id}';
  }
}
