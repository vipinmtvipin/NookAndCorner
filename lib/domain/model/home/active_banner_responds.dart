import 'dart:convert';

ActiveBannerResponds bannerRespondsFromJson(String str) =>
    ActiveBannerResponds.fromJson(json.decode(str));

String bannerRespondsToJson(ActiveBannerResponds data) =>
    json.encode(data.toJson());

class ActiveBannerResponds {
  ActiveBannerResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final ActiveBannerData? data;

  factory ActiveBannerResponds.fromJson(Map<String, dynamic> json) {
    return ActiveBannerResponds(
      success: json["success"],
      message: json["message"],
      data:
          json["data"] == null ? null : ActiveBannerData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class ActiveBannerData {
  ActiveBannerData({
    required this.banners,
    required this.pendingJobs,
    required this.pendingPayments,
  });

  final List<BannerData> banners;
  final int? pendingJobs;
  final int? pendingPayments;

  factory ActiveBannerData.fromJson(Map<String, dynamic> json) {
    return ActiveBannerData(
      banners: json["banners"] == null
          ? []
          : List<BannerData>.from(
              json["banners"]!.map((x) => BannerData.fromJson(x))),
      pendingJobs: json["pendingJobs"] ?? 0,
      pendingPayments: json["pendingPayments"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "banners": banners.map((x) => x.toJson()).toList(),
        "pendingJobs": pendingJobs ?? 0,
        "pendingPayments": pendingPayments ?? 0,
      };
}

class BannerData {
  BannerData({
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

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
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
}
