part of 'create_collection_bloc.dart';

sealed class CreateCollectionState extends Equatable {
  const CreateCollectionState();

  @override
  List<Object> get props => [];
}

final class CreateCollectionInitial extends CreateCollectionState {}

final class CreateCollectionSuccess extends CreateCollectionState {}

final class CreateCollectionFailure extends CreateCollectionState {}
