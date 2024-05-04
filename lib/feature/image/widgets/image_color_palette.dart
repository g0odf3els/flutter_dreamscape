import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/data/image/models/color.dart';

class ImageColorPalette extends StatelessWidget {
  const ImageColorPalette({super.key, this.colors});
  final List<ImageColor>? colors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 0,
        children: colors!.map((color) {
          return Container(
            width: MediaQuery.of(context).size.width / colors!.length - 5,
            height: 25.0,
            decoration: BoxDecoration(
              color: Color.fromRGBO(color.r, color.g, color.b, color.a / 255),
            ),
          );
        }).toList());
  }
}
