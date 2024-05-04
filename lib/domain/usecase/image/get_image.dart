import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';
import 'package:flutter_dreamscape/core/usecase/usecase.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';

class GetImage implements UseCase<ImageFile, ParamsGetImage> {
  final ImageRepositoryAbstract imageRepository;

  GetImage({required this.imageRepository});

  @override
  Future<Either<Failure, ImageFile>> call(ParamsGetImage params) async {
    return await imageRepository.getImage(params.id);
  }
}

class ParamsGetImage extends Equatable {
  final String id;

  const ParamsGetImage({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'ParamsGetImage{category: $id}';
  }
}
