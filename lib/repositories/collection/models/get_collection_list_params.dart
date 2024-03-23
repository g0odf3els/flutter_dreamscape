class GetCollectionListParams {
  int page;
  int pageSize;
  String? ownerId;

  GetCollectionListParams({this.page = 1, this.pageSize = 16, this.ownerId});
}
