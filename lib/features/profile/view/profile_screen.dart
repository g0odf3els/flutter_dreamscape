import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/features/image/view/view.dart';
import 'package:flutter_dreamscape/features/image/widgets/user_card.dart';
import 'package:flutter_dreamscape/features/image_list/image_list.dart';
import 'package:flutter_dreamscape/features/profile/bloc/profile_bloc.dart';
import 'package:flutter_dreamscape/features/share/widgets/collection_card.dart';
import 'package:flutter_dreamscape/features/share/widgets/image_card.dart';
import 'package:flutter_dreamscape/features/share/widgets/request_error.dart';
import 'package:flutter_dreamscape/repositories/collection/collection_repository_abstract.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';
import 'package:flutter_dreamscape/repositories/user/user.dart';
import 'package:get_it/get_it.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final imageBloc = ProfileBloc(
        userRepostiry: GetIt.I<UserRepostiryAbstract>(),
        imageRepository: GetIt.I<ImageRepositoryAbstract>(),
        collectionRepository: GetIt.I<CollectionRepositoryAbstract>())
      ..add(ProfileLoadRequest(widget.userId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
            bloc: imageBloc,
            builder: (context, state) {
              if (state is ProfileLoadSuccess) {
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(children: [
                      UserCard(user: state.user),
                      Flexible(
                          child: Container(
                              child: DefaultTabController(
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: 'Uploads'),
                                Tab(text: 'Collections'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.uploads.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageScreen(
                                                            fileId: state
                                                                .uploads[index]
                                                                .id)),
                                              );
                                            },
                                            child: ImageCard(
                                                file: state.uploads[index]));
                                      }),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.collections.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageListScreen(
                                                          params: GetImageListParams(
                                                              collectionId: state
                                                                  .collections[
                                                                      index]
                                                                  .id),
                                                        )),
                                              );
                                            },
                                            child: CollectionCard(
                                                collection:
                                                    state.collections[index]));
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )))
                    ]));
              }
              if (state is ProfileLoadFailure) {
                return RequestError(
                    errorMessage: 'Something went wrong.',
                    onRetry: () {
                      imageBloc.add(ProfileLoadRequest(widget.userId));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
