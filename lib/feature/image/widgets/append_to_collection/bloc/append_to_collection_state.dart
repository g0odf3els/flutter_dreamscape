part of 'append_to_collection_bloc.dart';

sealed class AppendToCollectionState extends Equatable {
  const AppendToCollectionState();

  @override
  List<Object> get props => [];
}

final class AppendToCollectionInitial extends AppendToCollectionState {}

final class AppendToCollectionLoadSuccess extends AppendToCollectionState {
  final List<Collection> collections;
  const AppendToCollectionLoadSuccess({required this.collections});

  @override
  List<Object> get props => [collections];
}

final class AppendToCollectionLoadFailure extends AppendToCollectionState {}

final class AppendToCollectionSucess extends AppendToCollectionState {}

final class AppendToCollectionFailure extends AppendToCollectionState {}

final class RemoveFromCollectionSucess extends AppendToCollectionState {}

final class RemoveFromCollectionFailure extends AppendToCollectionState {}
