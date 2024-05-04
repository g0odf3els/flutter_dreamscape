import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/collection/models/collection.dart';
import 'package:flutter_dreamscape/domain/repository/collection_repository_abstract.dart';

class CreateCollection implements UseCase<Collection, ParamsCreateCollection> {
  final CollectionRepositoryAbstract collectionRepository;

  CreateCollection({required this.collectionRepository});

  @override
  Future<Either<Failure, Collection>> call(
      ParamsCreateCollection params) async {
    return await collectionRepository.createCollection(
        name: params.name,
        description: params.description,
        isPublic: params.isPublic,
        filesId: params.filesId,
        accessToken: params.accessToken);
  }
}

class ParamsCreateCollection extends Equatable {
  final String name;
  final String? description;
  final bool? isPublic;
  final List<String>? filesId;
  final String accessToken;

  const ParamsCreateCollection(
      {required this.name,
      this.description,
      this.isPublic,
      this.filesId,
      required this.accessToken});

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'ParamsCreateoCollection{category: $id}';
  }
}
