part of 'image_list_bloc.dart';

class ImageListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ImageListLoadRequest extends ImageListEvent {
  final GetImageListParams params;
  ImageListLoadRequest({required this.params});
}

final class ImageListLoadNextPageRequest extends ImageListEvent {}

final class ImageListRefreshRequest extends ImageListEvent {}
