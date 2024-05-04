import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';

class UploadImage implements UseCase<void, ParamsUploadImage> {
  final ImageRepositoryAbstract imageRepository;

  UploadImage({required this.imageRepository});

  @override
  Future<Either<Failure, ImageFile>> call(ParamsUploadImage params) async {
    return await imageRepository.getImage(params.id);
  }
}

class ParamsUploadImage extends Equatable {
  final String id;

  const ParamsUploadImage({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'ParamsGetImage{category: $id}';
  }
}
