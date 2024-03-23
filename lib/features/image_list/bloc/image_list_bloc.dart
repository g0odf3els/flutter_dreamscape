import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';
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
  ImageListBloc({required this.imageRepository})
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

  final ImageRepositoryAbstract imageRepository;
  GetImageListParams params = GetImageListParams();

  Future<void> _onImageListLoad(
      ImageListLoadRequest event, Emitter<ImageListState> emit) async {
    try {
      params = event.params;

      final imagesPagedList =
          await imageRepository.getImagesList(params: params);

      emit(ImageListState(
          status: ImageListStatus.success,
          images: imagesPagedList.images,
          hasReachedMax: imagesPagedList.totalPages == params.page));
    } catch (_) {
      emit(state.copyWith(status: ImageListStatus.failure));
    }
  }

  Future<void> _onImageListLoadNextPage(
      ImageListLoadNextPageRequest event, Emitter<ImageListState> emit) async {
    try {
      if (state.hasReachedMax) {
        return;
      }

      params.page++;

      final imagesPagedList =
          await imageRepository.getImagesList(params: params);

      emit(state.copyWith(
        status: ImageListStatus.success,
        images: List.of(state.images)..addAll(imagesPagedList.images),
        hasReachedMax: imagesPagedList.totalPages == params.page,
      ));
    } catch (_) {
      emit(state.copyWith(status: ImageListStatus.failure));
    }
  }

  Future<void> _onImageListRefresh(
      ImageListRefreshRequest event, Emitter<ImageListState> emit) async {
    try {
      final imagesPagedList =
          await imageRepository.getImagesList(params: params);

      emit(ImageListState(
          status: ImageListStatus.success,
          images: imagesPagedList.images,
          hasReachedMax: imagesPagedList.totalPages == params.page));
    } catch (ex) {
      emit(state.copyWith(status: ImageListStatus.failure));
    }
  }
}
