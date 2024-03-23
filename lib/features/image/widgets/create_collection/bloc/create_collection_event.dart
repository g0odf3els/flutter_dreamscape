part of 'create_collection_bloc.dart';

sealed class CreateCollectionEvent extends Equatable {
  const CreateCollectionEvent();

  @override
  List<Object> get props => [];
}

final class CreateCollectionRequest extends CreateCollectionEvent {
  final String name;
  final String description;
  final bool isPrivate;
  const CreateCollectionRequest(
      {required this.name, required this.description, required this.isPrivate});
}
