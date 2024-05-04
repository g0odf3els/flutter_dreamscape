part of 'image_bloc.dart';

abstract class ImageState {
  const ImageState();
}

class ImageInital extends ImageState {}

class ImageLoadSuccess extends ImageState {
  final ImageFile image;

  ImageLoadSuccess(this.image);
}

class ImageLoadFailure extends ImageState {}
