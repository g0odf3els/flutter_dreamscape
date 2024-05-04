import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/collection/models/collection.dart';
import 'package:flutter_dreamscape/domain/repository/collection_repository_abstract.dart';

class AppendImageToCollection
    implements UseCase<Collection, ParamsAppendImageToCollection> {
  final CollectionRepositoryAbstract collectionRepository;

  AppendImageToCollection({required this.collectionRepository});

  @override
  Future<Either<Failure, Collection>> call(
      ParamsAppendImageToCollection params) async {
    return await collectionRepository.appendFileToCollection(
        collectionId: params.collectionId,
        fileId: params.fileId,
        accessToken: params.accessToken);
  }
}

class ParamsAppendImageToCollection extends Equatable {
  final String collectionId;
  final String fileId;
  final String accessToken;

  const ParamsAppendImageToCollection(
      {required this.collectionId,
      required this.fileId,
      required this.accessToken});

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'AppendImageToCollection{category: $id}';
  }
}
