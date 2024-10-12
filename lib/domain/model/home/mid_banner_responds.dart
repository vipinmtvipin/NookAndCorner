import 'dart:convert';

MidBannerResponds midBannerRespondsFromJson(String str) =>
    MidBannerResponds.fromJson(json.decode(str));

String midBannerServiceRespondsToJson(MidBannerResponds data) =>
    json.encode(data.toJson());

class MidBannerResponds {
  MidBannerResponds({
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
  final List<MidBannerData>? data;

  factory MidBannerResponds.fromJson(Map<String, dynamic> json) {
    return MidBannerResponds(
      success: json["success"],
      message: json["message"],
      statusCode: json["statusCode"],
      error: json["error"],
      data: json["data"] == null
          ? []
          : List<MidBannerData>.from(
              json["data"]!.map((x) => MidBannerData.fromJson(x))),
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

class MidBannerData {
  MidBannerData({
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

  factory MidBannerData.fromJson(Map<String, dynamic> json) {
    return MidBannerData(
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
}
