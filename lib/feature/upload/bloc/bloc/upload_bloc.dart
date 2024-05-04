import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/domain/repository/image_repository_abstract.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'upload_event.dart';
part 'upload_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final ImageRepositoryAbstract imageRepository;

  UploadBloc({required this.imageRepository}) : super(UploadInitial()) {
    on<UploadNewImageRequest>((event, emit) async {
      try {
        emit(UploadNewImageLoading());
        await imageRepository.uploadImage(event.file, event.accessToken);
        emit(UploadNewImageSuccess());
      } catch (ex) {
        emit(UploadNewImageFailure());
      }
    });
  }
}
