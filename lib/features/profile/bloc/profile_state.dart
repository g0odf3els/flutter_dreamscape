part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final User user;
  final List<ImageFile> uploads;
  final List<Collection> collections;

  const ProfileLoadSuccess(
      {required this.user, required this.uploads, required this.collections});
}

class ProfileLoadFailure extends ProfileState {}
