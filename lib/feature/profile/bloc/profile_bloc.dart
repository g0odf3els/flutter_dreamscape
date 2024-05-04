import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/data/collection/models/models.dart';
import 'package:flutter_dreamscape/data/image/image.dart';
import 'package:flutter_dreamscape/data/user/models/user.dart';
import 'package:flutter_dreamscape/domain/usecase/user/get_user.dart';
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
  final GetUser getUser;

  ProfileBloc({required this.getUser}) : super(ProfileInitial()) {
    on<ProfileLoadRequest>(
      _onProfileFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onProfileFetched(
      ProfileLoadRequest event, Emitter<ProfileState> emit) async {
    var userResult = await getUser(ParamsGetUser(id: event.id));

    userResult.fold((failure) {
      emit(ProfileLoadFailure());
    }, (data) => {emit(ProfileLoadSuccess(user: data))});
  }
}
