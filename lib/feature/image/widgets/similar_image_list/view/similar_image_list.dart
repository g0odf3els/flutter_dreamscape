import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_similar_image_list.dart';
import 'package:flutter_dreamscape/feature/image/image.dart';
import 'package:flutter_dreamscape/feature/image/widgets/similar_image_list/bloc/similar_image_list_bloc.dart';
import 'package:flutter_dreamscape/feature/share/widgets/image_card.dart';
import 'package:flutter_dreamscape/feature/share/widgets/request_error.dart';
import 'package:get_it/get_it.dart';

class SimilarImageList extends StatefulWidget {
  final ParamsGetPagedSimilarImageList params;

  const SimilarImageList({super.key, required this.params});

  @override
  State<SimilarImageList> createState() => _SimilarImageListState();
}

class _SimilarImageListState extends State<SimilarImageList> {
  final SimilarImageListBloc _imageListBloc = SimilarImageListBloc(
      getPagedSimilarImageList: GetIt.I<GetPagedSimilarImageList>());

  @override
  void initState() {
    super.initState();
    _imageListBloc.add(SimilarImageListLoadRequest(params: widget.params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimilarImageListBloc, SimilarImageListState>(
      bloc: _imageListBloc,
      builder: (context, state) {
        switch (state.status) {
          case SimilarImageListStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case SimilarImageListStatus.failure:
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 100),
              child: RequestError(
                  errorMessage: 'Something went wrong.',
                  onRetry: () {
                    _imageListBloc.add(
                        SimilarImageListLoadRequest(params: widget.params));
                  }),
            );
          case SimilarImageListStatus.success:
            if (state.images.isEmpty) {
              return const Center(child: Text('No images'));
            }
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ImageScreen(fileId: state.images[index].id)),
                        );
                      },
                      child: ImageCard(file: state.images[index]));
                });
        }
      },
    );
  }
}
