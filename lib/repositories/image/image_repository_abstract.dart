import 'dart:io';

import 'package:flutter_dreamscape/repositories/image/models/get_image_list_params.dart';

import 'models/image.dart';
import 'models/image_paged_list.dart';

abstract class ImageRepositoryAbstract {
  Future<ImagePagedList> getImagesList({required GetImageListParams params});

  Future<ImagePagedList> getSimilarImagesList(
      {required String fileId, required GetImageListParams params});

  Future<ImageFile> getImage(String id);

  Future<void> uploadImage(File file, String accessToken);

  Future<void> deleteImage(File file, String accessToken);
}
