import 'dart:convert';

import 'package:customerapp/core/utils/common_util.dart';
import 'package:get_it/get_it.dart';

CuponResponds cuponRespondsFromJson(String str) =>
    CuponResponds.fromJson(json.decode(str));

class CuponResponds {
  CuponResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<CouponData> data;

  factory CuponResponds.fromJson(Map<String, dynamic> json) {
    return CuponResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<CouponData>.from(
              json["data"]!.map((x) => CouponData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class CouponData {
  CouponData({
    required this.promotionId,
    required this.promotionName,
    required this.service,
    required this.subService,
    required this.startDate,
    required this.endDate,
    required this.promotionType,
    required this.discountOfferPrice,
    required this.bannerImage,
    required this.thumbImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.singleUse,
    required this.expired,
    required this.id,
    required this.promotionSubServiceId,
    required this.promoId,
  });

  final int? promotionId;
  final String? promotionName;
  final dynamic service;
  final dynamic subService;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? promotionType;
  final double? discountOfferPrice;
  final dynamic bannerImage;
  final dynamic thumbImage;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? singleUse;
  final String? expired;
  final int? id;
  final int? promotionSubServiceId;
  final int? promoId;

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      promotionId: json["promotionId"],
      promotionName: json["promotionName"],
      service: json["service"],
      subService: json["subService"],
      startDate: DateTime.tryParse(json["startDate"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      promotionType: json["promotionType"],
      discountOfferPrice:
          GetIt.I<CommonUtil>().toDouble(json["discountOfferPrice"]),
      bannerImage: json["bannerImage"],
      thumbImage: json["thumbImage"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      singleUse: json["singleUse"],
      expired: json["expired"],
      id: json["id"],
      promotionSubServiceId: json["promotionSubServiceId"],
      promoId: json["promoId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "promotionName": promotionName,
        "service": service,
        "subService": subService,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "promotionType": promotionType,
        "discountOfferPrice": discountOfferPrice,
        "bannerImage": bannerImage,
        "thumbImage": thumbImage,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "singleUse": singleUse,
        "expired": expired,
        "id": id,
        "promotionSubServiceId": promotionSubServiceId,
        "promoId": promoId,
      };
}
