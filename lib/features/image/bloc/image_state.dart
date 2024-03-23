part of 'image_bloc.dart';

abstract class ImageState {
  const ImageState();
}

class ImageInital extends ImageState {}

class ImageLoadSuccess extends ImageState {
  final ImageFile image;
  final List<ImageFile> similarImages;

  ImageLoadSuccess(this.image, this.similarImages);
}

class ImageLoadFailure extends ImageState {}
