import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/data/image/image.dart';

class ImagePagedList extends Equatable {
  const ImagePagedList(this.images, this.pageNumber, this.pageSize,
      this.totalCount, this.totalPages);

  final List<ImageFile> images;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  factory ImagePagedList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonImages = json['items'];
    final List<ImageFile> images = jsonImages
        .map((dynamic item) => ImageFile.fromJson(item as Map<String, dynamic>))
        .toList();

    return ImagePagedList(
        images,
        json['totalCount'] as int,
        json['pageNumber'] as int,
        json['pageSize'] as int,
        json['totalPages'] as int);
  }

  @override
  List<Object?> get props => [images, totalCount, pageNumber, pageSize];
}
