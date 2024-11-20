class ReviewRequest {
  String? limit;
  String? offset;
  String? search;

  ReviewRequest({
    this.limit,
    this.offset,
    this.search,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['limit'] = limit;
    data['offset'] = offset;
    data['search'] = search;
    return data;
  }
}
