import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/repositories/collection/collection_repository_abstract.dart';
import 'package:flutter_dreamscape/repositories/collection/models/models.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';
import 'package:flutter_dreamscape/repositories/image/models/image_paged_list.dart';
import 'package:flutter_dreamscape/repositories/user/models/user.dart';
import 'package:flutter_dreamscape/repositories/user/user.dart';
import 'package:stream_transform/stream_transform.dart';

part 'profile_event.dart';
part 'profile_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
      {required this.userRepostiry,
      required this.imageRepository,
      required this.collectionRepository})
      : super(ProfileInitial()) {
    on<ProfileLoadRequest>(
      _onProfileFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final UserRepostiryAbstract userRepostiry;
  final CollectionRepositoryAbstract collectionRepository;
  final ImageRepositoryAbstract imageRepository;

  Future<void> _onProfileFetched(
      ProfileLoadRequest event, Emitter<ProfileState> emit) async {
    try {
      User user = await userRepostiry.getUser(event.id);
      ImagePagedList uploads = await imageRepository.getImagesList(
          params: GetImageListParams(uploaderId: user.id));

      CollectionPagedList collections = await collectionRepository
          .getCollectionList(params: GetCollectionListParams(ownerId: user.id));

      emit(ProfileLoadSuccess(
          user: user,
          uploads: uploads.images,
          collections: collections.collections));
    } catch (_) {
      emit(ProfileLoadFailure());
    }
  }
}
