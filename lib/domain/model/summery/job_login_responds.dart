import 'dart:convert';

import 'package:customerapp/core/utils/common_util.dart';
import 'package:get_it/get_it.dart';

JobLoginResponds jobLoginRespondsFromJson(String str) =>
    JobLoginResponds.fromJson(json.decode(str));

class JobLoginResponds {
  JobLoginResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final JobLoginData? data;

  factory JobLoginResponds.fromJson(Map<String, dynamic> json) {
    return JobLoginResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : JobLoginData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };

  static JobLoginResponds empty() {
    return JobLoginResponds(
      success: false,
      message: "",
      data: JobLoginData(addOns: [], jobCreated: null),
    );
  }
}

class JobLoginData {
  JobLoginData({
    required this.addOns,
    required this.jobCreated,
  });

  final List<AddOn> addOns;
  final JobCreated? jobCreated;

  factory JobLoginData.fromJson(Map<String, dynamic> json) {
    return JobLoginData(
      addOns: json["addOns"] == null
          ? []
          : List<AddOn>.from(json["addOns"]!.map((x) => AddOn.fromJson(x))),
      jobCreated: json["jobCreated"] == null
          ? null
          : JobCreated.fromJson(json["jobCreated"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "addOns": addOns.map((x) => x.toJson()).toList(),
        "jobCreated": jobCreated?.toJson(),
      };
}

class AddOn {
  AddOn({
    required this.addonId,
    required this.addonPrice,
    required this.quantity,
    required this.serviceId,
  });

  final int? addonId;
  final int? addonPrice;
  final int? quantity;
  final int? serviceId;

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      addonId: json["addonId"],
      addonPrice: json["addonPrice"],
      quantity: json["quantity"],
      serviceId: json["serviceId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "addonId": addonId,
        "addonPrice": addonPrice,
        "quantity": quantity,
        "serviceId": serviceId,
      };
}

class JobCreated {
  JobCreated({
    required this.refundRetryCount,
    required this.jobId,
    required this.jobDate,
    required this.status,
    required this.userId,
    required this.servicePriceId,
    required this.assignedUserId,
    required this.promotionId,
    required this.txnId,
    required this.price,
    required this.convenienceFee,
    required this.conveniencePercent,
    required this.advanceAmount,
    required this.advancePercent,
    required this.promotionAmount,
    required this.advStatus,
    required this.goldenHoursCharge,
    required this.overNightHikePercentage,
    required this.isGolderHour,
    required this.serviceId,
    required this.dateString,
    required this.workerCount,
    required this.workHours,
    required this.slotInterval,
    required this.updatedAt,
    required this.createdAt,
    required this.bookingDate,
    required this.addressId,
    required this.assignedDate,
    required this.delete,
    required this.paymentStatus,
    required this.otp,
    required this.workDone,
    required this.promotionStatus,
    required this.addonId,
    required this.refundStatus,
    required this.cancelledAt,
    required this.completedAt,
    required this.refundAmount,
    required this.startOtp,
    required this.startTime,
    required this.endTime,
  });

  final int? refundRetryCount;
  final int? jobId;
  final DateTime? jobDate;
  final String? status;
  final int? userId;
  final int? servicePriceId;
  final int? assignedUserId;
  final int? promotionId;
  final String? txnId;
  final int? price;
  final double? convenienceFee;
  final String? conveniencePercent;
  final double? advanceAmount;
  final String? advancePercent;
  final int? promotionAmount;
  final String? advStatus;
  final double? goldenHoursCharge;
  final int? overNightHikePercentage;
  final bool? isGolderHour;
  final int? serviceId;
  final DateTime? dateString;
  final String? workerCount;
  final String? workHours;
  final String? slotInterval;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final dynamic bookingDate;
  final dynamic addressId;
  final dynamic assignedDate;
  final dynamic delete;
  final dynamic paymentStatus;
  final dynamic otp;
  final dynamic workDone;
  final dynamic promotionStatus;
  final dynamic addonId;
  final dynamic refundStatus;
  final dynamic cancelledAt;
  final dynamic completedAt;
  final dynamic refundAmount;
  final dynamic startOtp;
  final dynamic startTime;
  final dynamic endTime;

  factory JobCreated.fromJson(Map<String, dynamic> json) {
    return JobCreated(
      refundRetryCount: json["refundRetryCount"],
      jobId: json["jobId"],
      jobDate: DateTime.tryParse(json["jobDate"] ?? ""),
      status: json["status"],
      userId: json["userId"],
      servicePriceId: json["servicePriceId"],
      assignedUserId: json["assignedUserId"],
      promotionId: json["promotionId"],
      txnId: json["txnId"],
      price: json["price"],
      convenienceFee: json["convenienceFee"],
      conveniencePercent: json["conveniencePercent"],
      advanceAmount: json["advanceAmount"],
      advancePercent: json["advancePercent"],
      promotionAmount: json["promotionAmount"],
      advStatus: json["advStatus"],
      goldenHoursCharge:
          GetIt.I<CommonUtil>().toDouble(json["goldenHoursCharge"]),
      overNightHikePercentage: json["overNightHikePercentage"],
      isGolderHour: json["isGolderHour"],
      serviceId: json["serviceId"],
      dateString: DateTime.tryParse(json["dateString"] ?? ""),
      workerCount: json["workerCount"],
      workHours: json["workHours"],
      slotInterval: json["slotInterval"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      bookingDate: json["bookingDate"],
      addressId: json["addressId"],
      assignedDate: json["assignedDate"],
      delete: json["delete"],
      paymentStatus: json["paymentStatus"],
      otp: json["otp"],
      workDone: json["workDone"],
      promotionStatus: json["promotionStatus"],
      addonId: json["addonId"],
      refundStatus: json["refundStatus"],
      cancelledAt: json["cancelledAt"],
      completedAt: json["completedAt"],
      refundAmount: json["refundAmount"],
      startOtp: json["startOtp"],
      startTime: json["startTime"],
      endTime: json["endTime"],
    );
  }

  Map<String, dynamic> toJson() => {
        "refundRetryCount": refundRetryCount,
        "jobId": jobId,
        "jobDate": jobDate?.toIso8601String(),
        "status": status,
        "userId": userId,
        "servicePriceId": servicePriceId,
        "assignedUserId": assignedUserId,
        "promotionId": promotionId,
        "txnId": txnId,
        "price": price,
        "convenienceFee": convenienceFee,
        "conveniencePercent": conveniencePercent,
        "advanceAmount": advanceAmount,
        "advancePercent": advancePercent,
        "promotionAmount": promotionAmount,
        "advStatus": advStatus,
        "goldenHoursCharge": goldenHoursCharge,
        "overNightHikePercentage": overNightHikePercentage,
        "isGolderHour": isGolderHour,
        "serviceId": serviceId,
        "dateString": dateString?.toIso8601String(),
        "workerCount": workerCount,
        "workHours": workHours,
        "slotInterval": slotInterval,
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "bookingDate": bookingDate,
        "addressId": addressId,
        "assignedDate": assignedDate,
        "delete": delete,
        "paymentStatus": paymentStatus,
        "otp": otp,
        "workDone": workDone,
        "promotionStatus": promotionStatus,
        "addonId": addonId,
        "refundStatus": refundStatus,
        "cancelledAt": cancelledAt,
        "completedAt": completedAt,
        "refundAmount": refundAmount,
        "startOtp": startOtp,
        "startTime": startTime,
        "endTime": endTime,
      };
}
