import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/collection/models/models.dart';
import 'package:flutter_dreamscape/domain/repository/collection_repository_abstract.dart';

class GetPagedUserCollectionList
    implements UseCase<CollectionPagedList, ParamsGetPagedUserCollectionList> {
  final CollectionRepositoryAbstract collectionRepository;

  GetPagedUserCollectionList({required this.collectionRepository});

  @override
  Future<Either<Failure, CollectionPagedList>> call(
      ParamsGetPagedUserCollectionList params) async {
    return await collectionRepository.getUserCollectionList(
        page: params.page,
        pageSize: params.pageSize,
        accessToken: params.accessToken);
  }
}

class ParamsGetPagedUserCollectionList extends Equatable {
  final String accessToken;
  final int page;
  final int pageSize;

  const ParamsGetPagedUserCollectionList({
    required this.accessToken,
    this.page = 1,
    this.pageSize = 16,
  });

  @override
  List<Object?> get props => [page, pageSize];

  ParamsGetPagedUserCollectionList copyWith(
      {int? page, int? pageSize, String? ownderId}) {
    return ParamsGetPagedUserCollectionList(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        accessToken: ownderId ?? this.accessToken);
  }
}
