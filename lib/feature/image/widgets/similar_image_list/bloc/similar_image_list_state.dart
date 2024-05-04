part of 'similar_image_list_bloc.dart';

enum SimilarImageListStatus { initial, success, failure }

class SimilarImageListState extends Equatable {
  const SimilarImageListState(
      {this.status = SimilarImageListStatus.initial,
      this.images = const <ImageFile>[]});

  final SimilarImageListStatus status;
  final List<ImageFile> images;

  SimilarImageListState copyWith({
    SimilarImageListStatus? status,
    List<ImageFile>? images,
  }) {
    return SimilarImageListState(
      status: status ?? this.status,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return '''ImageListState { status: $status, images: ${images.length} }''';
  }

  @override
  List<Object> get props => [status, images];
}
