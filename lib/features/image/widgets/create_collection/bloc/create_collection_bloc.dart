import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_dreamscape/repositories/collection/collection_repository_abstract.dart';
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
  final CollectionRepositoryAbstract collectionRepository;

  CreateCollectionBloc({required this.collectionRepository})
      : super(CreateCollectionInitial()) {
    on<CreateCollectionEvent>((event, emit) async {});
  }
}
