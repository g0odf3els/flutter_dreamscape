import 'package:flutter/material.dart';
import 'package:flutter_dreamscape/data/image/models/image.dart';
import 'package:flutter_dreamscape/config/base_url_config.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.file});

  final ImageFile file;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Image.network(
            'https://${UrlHelper.baseUrl}:${UrlHelper.port}/${file.displaySizePath}',
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${file.resolution?.width}x${file.resolution?.height}"),
          ),
        ],
      ),
    );
  }
}
