part of 'image_list_bloc.dart';

enum ImageListStatus { initial, success, failure }

class ImageListState extends Equatable {
  const ImageListState(
      {this.status = ImageListStatus.initial,
      this.images = const <ImageFile>[],
      this.hasReachedMax = false});

  final ImageListStatus status;
  final List<ImageFile> images;
  final bool hasReachedMax;

  ImageListState copyWith({
    ImageListStatus? status,
    List<ImageFile>? images,
    bool? hasReachedMax,
  }) {
    return ImageListState(
      status: status ?? this.status,
      images: images ?? this.images,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''ImageListState { status: $status, hasReachedMax: $hasReachedMax, images: ${images.length} }''';
  }

  @override
  List<Object> get props => [status, images, hasReachedMax];
}
