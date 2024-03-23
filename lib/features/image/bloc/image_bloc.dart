import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';
import 'package:flutter_dreamscape/repositories/image/models/image_paged_list.dart';
import 'package:stream_transform/stream_transform.dart';

part 'image_event.dart';
part 'image_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc({required this.imageRepository}) : super(ImageInital()) {
    on<ImageLoadRequested>(
      _onImageFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final ImageRepositoryAbstract imageRepository;

  Future<void> _onImageFetched(
      ImageLoadRequested event, Emitter<ImageState> emit) async {
    try {
      ImageFile image = await imageRepository.getImage(event.id);
      ImagePagedList similarImages = await imageRepository.getSimilarImagesList(
          fileId: event.id, params: GetImageListParams(page: 4));
      emit(ImageLoadSuccess(image, similarImages.images));
    } catch (_) {
      emit(ImageLoadFailure());
    }
  }
}
