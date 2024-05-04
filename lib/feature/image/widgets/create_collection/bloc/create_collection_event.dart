part of 'create_collection_bloc.dart';

sealed class CreateCollectionEvent extends Equatable {
  const CreateCollectionEvent();

  @override
  List<Object> get props => [];
}

final class CreateCollectionRequest extends CreateCollectionEvent {
  final String name;
  final String? description;
  final bool? isPrivate;
  final List<String>? filesId;
  final String accessToken;
  const CreateCollectionRequest(
      {required this.name,
      this.description,
      this.isPrivate,
      this.filesId,
      required this.accessToken});
}
