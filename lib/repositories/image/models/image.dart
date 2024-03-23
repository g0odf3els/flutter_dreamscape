import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/repositories/user/models/user.dart';

import 'color.dart';
import 'resolution.dart';
import 'tag.dart';

class ImageFile extends Equatable {
  const ImageFile(
      {required this.id,
      required this.displaySizePath,
      required this.fullSizePath,
      required this.uploader,
      required this.uploaderId,
      this.tags,
      this.resolution,
      this.colors});

  final String id;
  final String displaySizePath;
  final String fullSizePath;
  final User uploader;
  final String uploaderId;
  final List<Tag>? tags;
  final List<ImageColor>? colors;
  final Resolution? resolution;

  factory ImageFile.fromJson(Map<String, dynamic> json) {
    return ImageFile(
      id: json['id'],
      displaySizePath: json['displaySizePath'],
      fullSizePath: json['fullSizePath'],
      uploader: User.fromJson(json['uploader']),
      uploaderId: json['uploaderId'],
      tags: json['tags'] != null
          ? List<Tag>.from(json['tags'].map((tag) => Tag.fromJson(tag)))
          : null,
      colors: json['colors'] != null
          ? List<ImageColor>.from(
              json['colors'].map((color) => ImageColor.fromJson(color)))
          : null,
      resolution: json['resolution'] != null
          ? Resolution.fromJson(json['resolution'])
          : null,
    );
  }

  @override
  List<Object?> get props => [id];
}
