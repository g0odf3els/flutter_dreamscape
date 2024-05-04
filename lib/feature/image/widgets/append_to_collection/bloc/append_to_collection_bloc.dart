import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/data/collection/models/models.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/append_image_to_collection.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/get_paged_user_collection_list.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/remove_image_from_collection.dart';
import 'package:stream_transform/stream_transform.dart';

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
  final GetPagedUserCollectionList getPagedCollectionList;
  final AppendImageToCollection appendImageToCollection;
  final RemoveImageFromCollection removeImageFromCollection;

  AppendToCollectionBloc(
      {required this.getPagedCollectionList,
      required this.appendImageToCollection,
      required this.removeImageFromCollection})
      : super(AppendToCollectionInitial()) {
    on<CollectionListLoadRequest>((event, emit) async {
      var result = await getPagedCollectionList(
          ParamsGetPagedUserCollectionList(accessToken: event.accessToken));

      result.fold(
          (error) => emit(AppendToCollectionLoadFailure()),
          (data) => emit(
              AppendToCollectionLoadSuccess(collections: data.collections)));
    });

    on<AppendToCollectionRequest>((event, emit) async {
      var result = await appendImageToCollection(ParamsAppendImageToCollection(
          collectionId: event.collectionId,
          fileId: event.fileId,
          accessToken: event.accessToken));

      result.fold((error) => emit(AppendToCollectionLoadFailure()), (data) {
        add(CollectionListLoadRequest(accessToken: event.accessToken));
      });
    });

    on<RemoveFromCollectionRequest>((event, emit) async {
      var result = await removeImageFromCollection(
          ParamsRemoveImageFromCollection(
              collectionId: event.collectionId,
              fileId: event.fileId,
              accessToken: event.accessToken));

      result.fold((error) => emit(AppendToCollectionLoadFailure()), (data) {
        add(CollectionListLoadRequest(accessToken: event.accessToken));
      });
    });
  }
}
