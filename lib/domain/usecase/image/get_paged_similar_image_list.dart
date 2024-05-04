import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';

class GetPagedSimilarImageList
    implements UseCase<ImagePagedList, ParamsGetPagedSimilarImageList> {
  final ImageRepositoryAbstract imageRepository;

  GetPagedSimilarImageList({required this.imageRepository});

  @override
  Future<Either<Failure, ImagePagedList>> call(
      ParamsGetPagedSimilarImageList params) async {
    return await imageRepository.getSimilarImagesList(
        fileId: params.fileId,
        page: params.page,
        pageSize: params.pageSize,
        search: params.search,
        resolutions: params.resolutions,
        aspectRations: params.aspectRations,
        uploaderId: params.uploaderId);
  }
}

class ParamsGetPagedSimilarImageList extends Equatable {
  final String fileId;
  final int page;
  final int pageSize;
  final String? search;
  final List<String>? resolutions;
  final List<String>? aspectRations;
  final String? uploaderId;
  final String? collectionId;

  const ParamsGetPagedSimilarImageList(
      {required this.fileId,
      this.page = 1,
      this.pageSize = 16,
      this.search,
      this.resolutions,
      this.aspectRations,
      this.uploaderId,
      this.collectionId});

  @override
  List<Object> get props => [];
}
