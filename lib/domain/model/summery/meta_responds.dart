import 'dart:convert';

MetaResponds metaRespondsFromJson(String str) =>
    MetaResponds.fromJson(json.decode(str));

class MetaResponds {
  MetaResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final MetasData? data;

  factory MetaResponds.fromJson(Map<String, dynamic> json) {
    return MetaResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : MetasData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class MetasData {
  MetasData({
    required this.advancePercentage,
    required this.conveniencePercentage,
    required this.androidVendorVersion,
    required this.partnerAppPlayStore,
    required this.nandcAppPlayStore,
    required this.cancelPenalty,
    required this.overNightHikePercentage,
    required this.latePenalty,
    required this.timeSlotGap,
    required this.nandcVendorCommission,
    required this.androidUserVersion,
    required this.vendorTds,
    required this.nandcAppStore,
  });

  final String? advancePercentage;
  final String? conveniencePercentage;
  final String? androidVendorVersion;
  final String? partnerAppPlayStore;
  final String? nandcAppPlayStore;
  final String? cancelPenalty;
  final String? overNightHikePercentage;
  final String? latePenalty;
  final String? timeSlotGap;
  final String? nandcVendorCommission;
  final String? androidUserVersion;
  final String? vendorTds;
  final String? nandcAppStore;

  factory MetasData.fromJson(Map<String, dynamic> json) {
    return MetasData(
      advancePercentage: json["advancePercentage"],
      conveniencePercentage: json["conveniencePercentage"],
      androidVendorVersion: json["androidVendorVersion"],
      partnerAppPlayStore: json["partnerAppPlayStore"],
      nandcAppPlayStore: json["nandcAppPlayStore"],
      cancelPenalty: json["cancelPenalty"],
      overNightHikePercentage: json["OverNightHikePercentage"],
      latePenalty: json["latePenalty"],
      timeSlotGap: json["timeSlotGap"],
      nandcVendorCommission: json["nandcVendorCommission"],
      androidUserVersion: json["androidUserVersion"],
      vendorTds: json["vendorTds"],
      nandcAppStore: json["nandcAppStore"],
    );
  }

  Map<String, dynamic> toJson() => {
        "advancePercentage": advancePercentage,
        "conveniencePercentage": conveniencePercentage,
        "androidVendorVersion": androidVendorVersion,
        "partnerAppPlayStore": partnerAppPlayStore,
        "nandcAppPlayStore": nandcAppPlayStore,
        "cancelPenalty": cancelPenalty,
        "OverNightHikePercentage": overNightHikePercentage,
        "latePenalty": latePenalty,
        "timeSlotGap": timeSlotGap,
        "nandcVendorCommission": nandcVendorCommission,
        "androidUserVersion": androidUserVersion,
        "vendorTds": vendorTds,
        "nandcAppStore": nandcAppStore,
      };

  static MetasData empty() {
    return MetasData(
      advancePercentage: '0',
      conveniencePercentage: '0',
      androidVendorVersion: '',
      partnerAppPlayStore: '',
      nandcAppPlayStore: '',
      cancelPenalty: '0',
      overNightHikePercentage: '0',
      latePenalty: '0',
      timeSlotGap: '',
      nandcVendorCommission: '0',
      androidUserVersion: '',
      vendorTds: '0',
      nandcAppStore: '',
    );
  }
}
