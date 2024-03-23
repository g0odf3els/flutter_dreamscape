import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/features/image_search_params/view/image_search_params.dart';
import 'package:flutter_dreamscape/features/login/login.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_dreamscape/features/image/image.dart';
import 'package:flutter_dreamscape/features/image_list/bloc/image_list_bloc.dart';
import 'package:flutter_dreamscape/features/share/widgets/image_card.dart';
import 'package:flutter_dreamscape/features/share/widgets/request_error.dart';

import 'package:flutter_dreamscape/repositories/image/image.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key, required this.params});

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
  final GetImageListParams params;
}

class _ImageListScreenState extends State<ImageListScreen> {
  final ImageListBloc _imageListBloc =
      ImageListBloc(imageRepository: GetIt.I<ImageRepositoryAbstract>());

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageListBloc.add(ImageListLoadRequest(params: widget.params));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
          endDrawerEnableOpenDragGesture: false,
          appBar: AppBar(
              title: const Text("Dreamscape"),
              actions: [
                if (state is AuthAuthenticatedState)
                  Row(children: [
                    Text(
                      state.user.username,
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<AuthBloc>().add(AuthLogoutEvent()),
                      splashRadius: 23,
                      icon: const Icon(Icons.logout),
                    )
                  ])
                else
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    ),
                    splashRadius: 23,
                    icon: const Icon(Icons.login),
                  ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "Search Images",
                            prefixIcon: Icon(Icons.search),
                          ),
                          onSubmitted: (searchText) {
                            _imageListBloc.add(ImageListLoadRequest(
                                params:
                                    GetImageListParams(search: searchText)));
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageSearchParams(
                                  params: GetImageListParams())),
                        );
                      },
                      icon: const Icon(Icons.settings_applications_sharp),
                      iconSize: 35,
                      padding: const EdgeInsets.only(top: 20.0, right: 5),
                    ),
                  ],
                ),
              )),
          body: RefreshIndicator(
            onRefresh: () async {
              _imageListBloc.add(ImageListRefreshRequest());
            },
            child: Column(
              children: [
                Expanded(
                    child: BlocBuilder<ImageListBloc, ImageListState>(
                  bloc: _imageListBloc,
                  builder: (context, state) {
                    switch (state.status) {
                      case ImageListStatus.initial:
                        return const Center(child: CircularProgressIndicator());
                      case ImageListStatus.failure:
                        return RequestError(
                            errorMessage: 'Something went wrong.',
                            onRetry: () {
                              _imageListBloc.add(ImageListRefreshRequest());
                            });
                      case ImageListStatus.success:
                        if (state.images.isEmpty) {
                          return const Center(child: Text('No images'));
                        }
                        return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return index >= state.images.length
                                    ? const BottomLoader()
                                    : GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageScreen(
                                                        fileId: state
                                                            .images[index].id)),
                                          );
                                        },
                                        child: ImageCard(
                                            file: state.images[index]));
                              },
                              itemCount: state.hasReachedMax
                                  ? state.images.length
                                  : state.images.length + 1,
                              controller: _scrollController,
                            ));
                    }
                  },
                ))
              ],
            ),
          ));
    });
  }

  void _onScroll() {
    if (_isBottom) _imageListBloc.add(ImageListLoadNextPageRequest());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LinearProgressIndicator(),
    );
  }
}
