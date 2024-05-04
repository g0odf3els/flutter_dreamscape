import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_similar_image_list.dart';
import 'package:stream_transform/stream_transform.dart';

part 'similar_image_list_event.dart';
part 'similar_image_list_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SimilarImageListBloc
    extends Bloc<SimilarImageListEvent, SimilarImageListState> {
  final GetPagedSimilarImageList getPagedSimilarImageList;

  SimilarImageListBloc({required this.getPagedSimilarImageList})
      : super(const SimilarImageListState()) {
    on<SimilarImageListLoadRequest>(
      _onSimilarImageListLoad,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onSimilarImageListLoad(SimilarImageListLoadRequest event,
      Emitter<SimilarImageListState> emit) async {
    var response = await getPagedSimilarImageList(event.params);

    response.fold((failure) {
      emit(state.copyWith(status: SimilarImageListStatus.failure));
    },
        (data) => {
              emit(SimilarImageListState(
                  status: SimilarImageListStatus.success, images: data.images))
            });
  }
}
