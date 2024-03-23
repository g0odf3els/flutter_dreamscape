import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/repositories/image/image.dart';

class ImageResolution extends StatelessWidget {
  const ImageResolution({super.key, this.resolution});
  final Resolution? resolution;
  @override
  Widget build(BuildContext context) {
    if (resolution == null) {
      return Container();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${resolution!.width} x ${resolution!.height}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
