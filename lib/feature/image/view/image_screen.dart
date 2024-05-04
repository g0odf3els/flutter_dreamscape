import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/core/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_image.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_similar_image_list.dart';
import 'package:flutter_dreamscape/feature/image/widgets/append_to_collection/view/append_to_collection_widget.dart';
import 'package:flutter_dreamscape/feature/image/widgets/create_collection/view/create_collection_widget.dart';
import 'package:flutter_dreamscape/feature/image/widgets/similar_image_list/view/similar_image_list.dart';
import 'package:flutter_dreamscape/feature/image/widgets/user_card.dart';
import 'package:flutter_dreamscape/feature/login/login.dart';
import 'package:flutter_dreamscape/feature/profile/view/profile_screen.dart';
import 'package:flutter_dreamscape/config/base_url_config.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_dreamscape/feature/image/bloc/image_bloc.dart';
import 'package:flutter_dreamscape/feature/image/widgets/widgets.dart';

import 'package:flutter_dreamscape/feature/share/widgets/request_error.dart';

import 'package:http/http.dart' as http;

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.fileId});

  final String fileId;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    final imageBloc = ImageBloc(getImage: GetIt.I<GetImage>())
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
                                'https://${UrlHelper.baseUrl}:${UrlHelper.port}/${state.image.displaySizePath}'),
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
                                              CreateCollectionWidget(
                                                fileId: widget.fileId,
                                              )
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
                          onPressed: () async {
                            if (!await FlutterFileDialog
                                .isPickDirectorySupported()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Directory selection is not supported'),
                                ),
                              );
                            }

                            final pickedDirectory =
                                await FlutterFileDialog.pickDirectory();

                            if (pickedDirectory != null) {
                              var uri = Uri.https(
                                  '${UrlHelper.baseUrl}:${UrlHelper.port}',
                                  state.image.fullSizePath);

                              http.Response response = await http.get(uri);

                              var path =
                                  await FlutterFileDialog.saveFileToDirectory(
                                directory: pickedDirectory,
                                data: response.bodyBytes,
                                mimeType: "image/jpeg",
                                fileName: "${state.image.id}.jpeg",
                                replace: true,
                              );

                              if (path != null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        'Image saved successfully at $path'),
                                  ));
                                }
                              }
                            }
                          },
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
                        SimilarImageList(
                            params: ParamsGetPagedSimilarImageList(
                                fileId: state.image.id))
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
