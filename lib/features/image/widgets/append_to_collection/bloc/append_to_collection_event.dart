part of 'append_to_collection_bloc.dart';

sealed class AppendToCollectionEvent extends Equatable {
  const AppendToCollectionEvent();

  @override
  List<Object> get props => [];
}

final class CollectionListLoadRequest extends AppendToCollectionEvent {
  final String accessToken;
  const CollectionListLoadRequest({required this.accessToken});
}

final class AppendToCollectionRequest extends AppendToCollectionEvent {
  final String accessToken;
  final String collectionId;
  final String fileId;
  const AppendToCollectionRequest(
      {required this.accessToken,
      required this.collectionId,
      required this.fileId});
}

final class RemoveFromCollectionRequest extends AppendToCollectionEvent {
  final String accessToken;
  final String collectionId;
  final String fileId;
  const RemoveFromCollectionRequest(
      {required this.accessToken,
      required this.collectionId,
      required this.fileId});
}
