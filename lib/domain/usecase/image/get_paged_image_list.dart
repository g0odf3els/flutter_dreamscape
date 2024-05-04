import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';

class GetPagedImageList
    implements UseCase<ImagePagedList, ParamsGetPagedImageList> {
  final ImageRepositoryAbstract imageRepository;

  GetPagedImageList({required this.imageRepository});

  @override
  Future<Either<Failure, ImagePagedList>> call(
      ParamsGetPagedImageList params) async {
    return await imageRepository.getImagesList(
        page: params.page,
        pageSize: params.pageSize,
        search: params.search,
        resolutions: params.resolutions,
        aspectRations: params.aspectRations,
        uploaderId: params.uploaderId);
  }
}

class ParamsGetPagedImageList extends Equatable {
  final int page;
  final int pageSize;
  final String? search;
  final List<String>? resolutions;
  final List<String>? aspectRations;
  final String? uploaderId;
  final String? collectionId;

  const ParamsGetPagedImageList({
    this.page = 1,
    this.pageSize = 16,
    this.search,
    this.resolutions,
    this.aspectRations,
    this.uploaderId,
    this.collectionId,
  });

  @override
  List<Object?> get props => [
        page,
        pageSize,
        search,
        resolutions,
        aspectRations,
        uploaderId,
        collectionId,
      ];

  ParamsGetPagedImageList copyWith({
    int? page,
    int? pageSize,
    String? search,
    List<String>? resolutions,
    List<String>? aspectRations,
    String? uploaderId,
    String? collectionId,
  }) {
    return ParamsGetPagedImageList(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search ?? this.search,
      resolutions: resolutions ?? this.resolutions,
      aspectRations: aspectRations ?? this.aspectRations,
      uploaderId: uploaderId ?? this.uploaderId,
      collectionId: collectionId ?? this.collectionId,
    );
  }
}
