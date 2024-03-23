class GetImageListParams {
  int page;
  int pageSize;
  String? search;
  List<String>? resolutions;
  List<String>? aspectRations;
  String? uploaderId;
  String? collectionId;

  GetImageListParams(
      {this.page = 1,
      this.pageSize = 16,
      this.search,
      this.resolutions,
      this.aspectRations,
      this.uploaderId,
      this.collectionId});
}
