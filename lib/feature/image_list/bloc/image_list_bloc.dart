import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_image_list.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'image_list_event.dart';
part 'image_list_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ImageListBloc extends Bloc<ImageListEvent, ImageListState> {
  final GetPagedImageList getPagedImageList;

  ImageListBloc({required this.getPagedImageList})
      : super(const ImageListState()) {
    on<ImageListLoadRequest>(
      _onImageListLoad,
      transformer: throttleDroppable(throttleDuration),
    );

    on<ImageListLoadNextPageRequest>(
      _onImageListLoadNextPage,
      transformer: throttleDroppable(throttleDuration),
    );

    on<ImageListRefreshRequest>(
      _onImageListRefresh,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  ParamsGetPagedImageList params = const ParamsGetPagedImageList();

  Future<void> _onImageListLoad(
      ImageListLoadRequest event, Emitter<ImageListState> emit) async {
    var response = await getPagedImageList(event.params);
    params = event.params;

    response.fold((failure) {
      emit(state.copyWith(status: ImageListStatus.failure));
    },
        (data) => {
              emit(ImageListState(
                  status: ImageListStatus.success,
                  images: data.images,
                  hasReachedMax: data.totalPages == params.page))
            });
  }

  Future<void> _onImageListLoadNextPage(
      ImageListLoadNextPageRequest event, Emitter<ImageListState> emit) async {
    if (state.hasReachedMax) {
      return;
    }

    params = params.copyWith(page: params.page + 1);
    var response = await getPagedImageList(params);

    response.fold((failure) {
      emit(state.copyWith(status: ImageListStatus.failure));
    },
        (data) => {
              emit(ImageListState(
                  status: ImageListStatus.success,
                  images: List.of(state.images)..addAll(data.images),
                  hasReachedMax: data.totalPages == params.page))
            });
  }

  Future<void> _onImageListRefresh(
      ImageListRefreshRequest event, Emitter<ImageListState> emit) async {
    params = params.copyWith(page: 1);

    var response = await getPagedImageList(params);

    response.fold((failure) {
      emit(state.copyWith(status: ImageListStatus.failure));
    },
        (data) => {
              emit(ImageListState(
                  status: ImageListStatus.success,
                  images: data.images,
                  hasReachedMax: data.totalPages == params.page))
            });
  }
}
