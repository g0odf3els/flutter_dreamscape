import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/blocs/auth/auth_bloc.dart';
import 'package:flutter_dreamscape/features/upload/bloc/bloc/upload_bloc.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final UploadBloc _uploadBloc = UploadBloc(
    imageRepository: GetIt.I<ImageRepositoryAbstract>(),
  );

  File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: _image == null
                  ? const Text('No Image selected')
                  : Column(
                      children: [
                        Image.file(_image!),
                        MaterialButton(
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            _uploadBloc.add(UploadNewImageRequest(
                                file: _image!,
                                accessToken: (context.read<AuthBloc>().state
                                        as AuthAuthenticatedState)
                                    .user
                                    .accessToken));
                          },
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Upload',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: showOptions,
              child: const SizedBox(
                width: double.infinity,
                child: Text(
                  'Select Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
