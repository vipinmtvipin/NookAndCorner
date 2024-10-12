import 'dart:convert';

ActiveBannerResponds bannerRespondsFromJson(String str) =>
    ActiveBannerResponds.fromJson(json.decode(str));

String bannerRespondsToJson(ActiveBannerResponds data) =>
    json.encode(data.toJson());

class ActiveBannerResponds {
  ActiveBannerResponds({
    this.success,
    this.message,
    this.statusCode,
    this.error,
    this.data,
  });

  final bool? success;
  final String? message;
  final int? statusCode;
  final String? error;
  final List<ActiveBannerData>? data;

  factory ActiveBannerResponds.fromJson(Map<String, dynamic> json) {
    return ActiveBannerResponds(
      success: json["success"],
      message: json["message"],
      statusCode: json["statusCode"],
      error: json["error"],
      data: json["data"] == null
          ? []
          : List<ActiveBannerData>.from(
              json["data"]!.map((x) => ActiveBannerData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "error": error,
        "data": data?.map((x) => x?.toJson()).toList(),
      };
}

class ActiveBannerData {
  ActiveBannerData({
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

  factory ActiveBannerData.fromJson(Map<String, dynamic> json) {
    return ActiveBannerData(
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

  static List<ActiveBannerData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ActiveBannerData.fromJson(json)).toList();
  }
}
