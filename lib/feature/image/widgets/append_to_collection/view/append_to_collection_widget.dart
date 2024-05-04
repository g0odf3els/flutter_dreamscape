import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/core/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/append_image_to_collection.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/get_paged_user_collection_list.dart';
import 'package:flutter_dreamscape/domain/usecase/collection/remove_image_from_collection.dart';
import 'package:flutter_dreamscape/feature/image/widgets/append_to_collection/bloc/append_to_collection_bloc.dart';
import 'package:flutter_dreamscape/feature/share/widgets/collection_card.dart';
import 'package:get_it/get_it.dart';

class AppendToCollectionWidget extends StatefulWidget {
  const AppendToCollectionWidget({super.key, required this.fileId});

  final String fileId;

  @override
  State<AppendToCollectionWidget> createState() =>
      _AppendToCollectionWidgetState();
}

class _AppendToCollectionWidgetState extends State<AppendToCollectionWidget> {
  late AppendToCollectionBloc appendToCollectionBloc;

  @override
  void initState() {
    super.initState();
    appendToCollectionBloc = AppendToCollectionBloc(
      getPagedCollectionList: GetIt.I<GetPagedUserCollectionList>(),
      appendImageToCollection: GetIt.I<AppendImageToCollection>(),
      removeImageFromCollection: GetIt.I<RemoveImageFromCollection>(),
    )..add(
        CollectionListLoadRequest(
          accessToken:
              (context.read<AuthBloc>().state as AuthAuthenticatedState)
                  .user
                  .accessToken,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppendToCollectionBloc, AppendToCollectionState>(
      bloc: appendToCollectionBloc,
      builder: (context, state) {
        if (state is AppendToCollectionLoadSuccess) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.collections.length,
              itemBuilder: (context, index) {
                final collection = state.collections[index];
                final inCollection =
                    collection.files.any((f) => f.id == widget.fileId);
                return GestureDetector(
                  onTap: () {
                    if (inCollection) {
                      appendToCollectionBloc.add(
                        RemoveFromCollectionRequest(
                          fileId: widget.fileId,
                          collectionId: collection.id,
                          accessToken: (context.read<AuthBloc>().state
                                  as AuthAuthenticatedState)
                              .user
                              .accessToken,
                        ),
                      );
                    } else {
                      appendToCollectionBloc.add(
                        AppendToCollectionRequest(
                          fileId: widget.fileId,
                          collectionId: collection.id,
                          accessToken: (context.read<AuthBloc>().state
                                  as AuthAuthenticatedState)
                              .user
                              .accessToken,
                        ),
                      );
                    }
                  },
                  child: CollectionCard(
                    collection: collection,
                    inCollection: inCollection,
                  ),
                );
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void dispose() {
    appendToCollectionBloc.close();
    super.dispose();
  }
}
