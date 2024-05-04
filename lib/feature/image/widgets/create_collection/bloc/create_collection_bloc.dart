import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/create_collection.dart';
import 'package:stream_transform/stream_transform.dart';

part 'create_collection_event.dart';
part 'create_collection_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CreateCollectionBloc
    extends Bloc<CreateCollectionEvent, CreateCollectionState> {
  final CreateCollection createCollection;

  CreateCollectionBloc({required this.createCollection})
      : super(CreateCollectionInitial()) {
    on<CreateCollectionRequest>((event, emit) async {
      var result = await createCollection(ParamsCreateCollection(
          name: event.name,
          description: event.description,
          isPublic: event.isPrivate,
          filesId: event.filesId,
          accessToken: event.accessToken));

      result.fold((error) => emit(CreateCollectionFailure()), (data) {
        emit(CreateCollectionSuccess());
      });
    });
  }
}
