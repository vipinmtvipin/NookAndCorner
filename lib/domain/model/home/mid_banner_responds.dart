class MidBannerResponds {
  MidBannerResponds({
    required this.midBannerId,
    required this.routePath,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? midBannerId;
  final String? routePath;
  final String? image;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MidBannerResponds.fromJson(Map<String, dynamic> json) {
    return MidBannerResponds(
      midBannerId: json["midBannerId"],
      routePath: json["routePath"],
      image: json["image"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "midBannerId": midBannerId,
        "routePath": routePath,
        "image": image,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  static List<MidBannerResponds> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MidBannerResponds.fromJson(json)).toList();
  }
}
