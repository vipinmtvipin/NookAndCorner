class ActiveBannerResponds {
  ActiveBannerResponds({
    required this.bannerId,
    required this.routePath,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? bannerId;
  final String? routePath;
  final String? image;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ActiveBannerResponds.fromJson(Map<String, dynamic> json) {
    return ActiveBannerResponds(
      bannerId: json["bannerId"],
      routePath: json["routePath"],
      image: json["image"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "bannerId": bannerId,
        "routePath": routePath,
        "image": image,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  static List<ActiveBannerResponds> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ActiveBannerResponds.fromJson(json)).toList();
  }
}
