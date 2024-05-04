import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_dreamscape/core/error/failure.dart';

import '../../data/image/models/image.dart';
import '../../data/image/models/image_paged_list.dart';

abstract class ImageRepositoryAbstract {
  Future<Either<Failure, ImagePagedList>> getImagesList(
      {int page = 1,
      int pageSize = 16,
      String? search,
      List<String>? resolutions,
      List<String>? aspectRations,
      String? uploaderId,
      String? collectionId});

  Future<Either<Failure, ImagePagedList>> getSimilarImagesList(
      {required String fileId,
      int page = 1,
      int pageSize = 16,
      String? search,
      List<String>? resolutions,
      List<String>? aspectRations,
      String? uploaderId,
      String? collectionId});

  Future<Either<Failure, ImageFile>> getImage(String id);

  Future<void> uploadImage(File file, String accessToken);

  Future<void> deleteImage(File file, String accessToken);
}
