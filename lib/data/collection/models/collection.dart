import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/data/image/models/models.dart';

class Collection extends Equatable {
  const Collection({
    required this.id,
    required this.name,
    required this.tags,
    required this.files,
  });

  final String id;
  final String name;
  final List<Tag> tags;
  final List<ImageFile> files;

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      name: json['name'],
      tags: List<Tag>.from(json['tags'].map((tag) => Tag.fromJson(tag))),
      files: List<ImageFile>.from(
          json['files'].map((file) => ImageFile.fromJson(file))),
    );
  }

  @override
  List<Object?> get props => [id, name, tags, files];

  @override
  bool get stringify => true;
}
