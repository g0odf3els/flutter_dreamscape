import 'package:equatable/equatable.dart';
import 'package:flutter_dreamscape/repositories/collection/models/models.dart';

class CollectionPagedList extends Equatable {
  const CollectionPagedList(this.collections, this.pageNumber, this.pageSize,
      this.totalCount, this.totalPages);

  final List<Collection> collections;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  factory CollectionPagedList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonCollections = json['items'];
    final List<Collection> collections = jsonCollections
        .map(
            (dynamic item) => Collection.fromJson(item as Map<String, dynamic>))
        .toList();

    CollectionPagedList cpl = CollectionPagedList(
        collections,
        json['totalCount'] as int,
        json['pageNumber'] as int,
        json['pageSize'] as int,
        json['totalPages'] as int);

    return cpl;
  }

  @override
  List<Object?> get props => [collections, totalCount, pageNumber, pageSize];
}
