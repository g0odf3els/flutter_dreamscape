import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/features/image/widgets/append_to_collection/view/append_to_collection_widget.dart';
import 'package:flutter_dreamscape/features/image/widgets/user_card.dart';
import 'package:flutter_dreamscape/features/login/login.dart';
import 'package:flutter_dreamscape/features/profile/view/profile_screen.dart';
import 'package:flutter_dreamscape/repositories/url_helper.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_dreamscape/features/image/bloc/image_bloc.dart';
import 'package:flutter_dreamscape/features/image/widgets/widgets.dart';
import 'package:flutter_dreamscape/features/share/widgets/image_card.dart';

import 'package:flutter_dreamscape/repositories/image/image.dart';

import 'package:flutter_dreamscape/features/share/widgets/request_error.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.fileId});

  final String fileId;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    final imageBloc =
        ImageBloc(imageRepository: GetIt.I<ImageRepositoryAbstract>())
          ..add(ImageLoadRequested(widget.fileId));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Detail'),
        ),
        body: BlocBuilder<ImageBloc, ImageState>(
            bloc: imageBloc,
            builder: (context, state) {
              if (state is ImageLoadSuccess) {
                return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageResolution(resolution: state.image.resolution),
                        const SizedBox(height: 10),
                        ImageDisplay(
                            imagePath:
                                'https://${UrlHelper.baseUrl}/${state.image.displaySizePath}'),
                        const SizedBox(height: 10),
                        ImageColorPalette(colors: state.image.colors),
                        const SizedBox(height: 10),
                        MaterialButton(
                          height: 50,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            if (context.read<AuthBloc>().state
                                is AuthAuthenticatedState) {
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(0)),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return DefaultTabController(
                                    length: 2,
                                    child: Column(
                                      children: [
                                        const TabBar(
                                          tabs: [
                                            Tab(text: 'Collections'),
                                            Tab(text: 'Create'),
                                          ],
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            children: [
                                              AppendToCollectionWidget(
                                                  fileId: widget.fileId),
                                              const Placeholder(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            }
                          },
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Add to collection',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          height: 50,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {},
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Download',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        userId: state.image.uploaderId)),
                              );
                            },
                            child: UserCard(user: state.image.uploader)),
                        const SizedBox(height: 10),
                        TagList(tags: state.image.tags),
                        const SizedBox(height: 10),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.similarImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageScreen(
                                              fileId: state
                                                  .similarImages[index].id)),
                                    );
                                  },
                                  child: ImageCard(
                                      file: state.similarImages[index]));
                            })
                      ],
                    )));
              }
              if (state is ImageLoadFailure) {
                return RequestError(
                    errorMessage: 'Something went wrong.',
                    onRetry: () {
                      imageBloc.add(ImageLoadRequested(widget.fileId));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
