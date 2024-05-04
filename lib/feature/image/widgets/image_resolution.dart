import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/data/image/image.dart';

class ImageResolution extends StatelessWidget {
  const ImageResolution({super.key, required this.resolution});
  final Resolution? resolution;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resolution != null
              ? '${resolution!.width} x ${resolution!.height}'
              : 'None',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
