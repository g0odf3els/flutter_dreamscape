part of 'similar_image_list_bloc.dart';

class SimilarImageListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SimilarImageListLoadRequest extends SimilarImageListEvent {
  final ParamsGetPagedSimilarImageList params;
  SimilarImageListLoadRequest({required this.params});
}
