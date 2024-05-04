import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_image.dart';
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
  final GetImage getImage;

  ImageBloc({required this.getImage}) : super(ImageInital()) {
    on<ImageLoadRequested>(
      _onImageFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onImageFetched(
      ImageLoadRequested event, Emitter<ImageState> emit) async {
    var response = await getImage(ParamsGetImage(id: event.id));

    response.fold((failure) {
      emit(ImageLoadFailure());
    }, (data) => {emit(ImageLoadSuccess(data))});
  }
}
