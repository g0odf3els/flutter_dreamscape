import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/domain/usecase/image/get_paged_image_list.dart';
import 'package:flutter_dreamscape/feature/image_list/image_list.dart';
import 'package:flutter_dreamscape/data/image/image.dart';

class TagList extends StatelessWidget {
  const TagList({super.key, this.tags});
  final List<Tag>? tags;
  @override
  Widget build(BuildContext context) {
    if (tags == null) {
      return Container();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
          spacing: 2.0,
          runSpacing: 6.0,
          alignment: WrapAlignment.start,
          children: tags!.map((tag) {
            return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageListScreen(
                                params: ParamsGetPagedImageList(
                                    search: tag.name))));
                  },
                  child: Text(
                    tag.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ));
          }).toList()),
    );
  }
}
