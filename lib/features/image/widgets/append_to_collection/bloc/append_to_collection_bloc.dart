import 'package:bloc/bloc.dart';
import 'package:flutter_dreamscape/repositories/collection/collection_repository_abstract.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/repositories/collection/models/models.dart';

part 'append_to_collection_event.dart';
part 'append_to_collection_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AppendToCollectionBloc
    extends Bloc<AppendToCollectionEvent, AppendToCollectionState> {
  final CollectionRepositoryAbstract collectionRepository;

  AppendToCollectionBloc({required this.collectionRepository})
      : super(AppendToCollectionInitial()) {
    on<CollectionListLoadRequest>((event, emit) async {
      try {
        var collectionPagedList =
            await collectionRepository.getUserCollectionList(
                params: GetCollectionListParams(),
                accessToken: event.accessToken);
        emit(AppendToCollectionLoadSuccess(
            collections: collectionPagedList.collections));
      } catch (ex) {
        emit(AppendToCollectionLoadFailure());
      }
    });

    on<AppendToCollectionRequest>((event, emit) async {
      try {
        await collectionRepository.appendFileToCollection(
            collectionId: event.collectionId,
            fileId: event.fileId,
            accessToken: event.accessToken);

        var collectionPagedList =
            await collectionRepository.getUserCollectionList(
                params: GetCollectionListParams(),
                accessToken: event.accessToken);

        emit(AppendToCollectionLoadSuccess(
            collections: collectionPagedList.collections));
      } catch (ex) {
        emit(AppendToCollectionFailure());
      }
    });

    on<RemoveFromCollectionRequest>((event, emit) async {
      try {
        await collectionRepository.removeFileFromCollection(
            collectionId: event.collectionId,
            fileId: event.fileId,
            accessToken: event.accessToken);

        var collectionPagedList =
            await collectionRepository.getUserCollectionList(
                params: GetCollectionListParams(),
                accessToken: event.accessToken);

        emit(AppendToCollectionLoadSuccess(
            collections: collectionPagedList.collections));
      } catch (ex) {
        emit(RemoveFromCollectionFailure());
      }
    });
  }
}
