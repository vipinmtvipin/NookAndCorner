import 'dart:convert';

JobResponds jobRespondsFromJson(String str) =>
    JobResponds.fromJson(json.decode(str));

class JobResponds {
  JobResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory JobResponds.fromJson(Map<String, dynamic> json) {
    return JobResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };

  static JobResponds empty() {
    return JobResponds(
      success: false,
      message: "",
      data: null,
    );
  }
}

class Data {
  Data({
    required this.accessToken,
    required this.jobData,
    required this.userData,
    required this.jobCreated,
  });

  final String? accessToken;
  final JobData? jobData;
  final UserData? userData;
  final JobCreated? jobCreated;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      accessToken: json["accessToken"],
      jobData:
          json["jobData"] == null ? null : JobData.fromJson(json["jobData"]),
      userData:
          json["userData"] == null ? null : UserData.fromJson(json["userData"]),
      jobCreated: json["jobCreated"] == null
          ? null
          : JobCreated.fromJson(json["jobCreated"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "jobData": jobData?.toJson(),
        "userData": userData?.toJson(),
        "jobCreated": jobCreated?.toJson(),
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
    required this.price,
    required this.txnId,
    required this.convenienceFee,
    required this.conveniencePercent,
    required this.advanceAmount,
    required this.advancePercent,
    required this.promotionAmount,
    required this.advStatus,
    required this.isGolderHour,
    required this.goldenHoursCharge,
    required this.overNightHikePercentage,
    required this.serviceId,
    required this.dateString,
    required this.workerCount,
    required this.workHours,
    required this.slotInterval,
    required this.aggCommissionPercent,
    required this.updatedAt,
    required this.createdAt,
    required this.bookingDate,
    required this.addressId,
    required this.assignedDate,
    required this.delete,
    required this.paymentStatus,
    required this.otp,
    required this.workDone,
    required this.addlPromotionId,
    required this.addlPromotionAmount,
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
  final dynamic promotionId;
  final int? price;
  final String? txnId;
  final double? convenienceFee;
  final String? conveniencePercent;
  final double? advanceAmount;
  final String? advancePercent;
  final dynamic promotionAmount;
  final String? advStatus;
  final bool? isGolderHour;
  final int? goldenHoursCharge;
  final int? overNightHikePercentage;
  final int? serviceId;
  final DateTime? dateString;
  final String? workerCount;
  final String? workHours;
  final String? slotInterval;
  final int? aggCommissionPercent;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final dynamic bookingDate;
  final dynamic addressId;
  final dynamic assignedDate;
  final dynamic delete;
  final dynamic paymentStatus;
  final dynamic otp;
  final dynamic workDone;
  final dynamic addlPromotionId;
  final dynamic addlPromotionAmount;
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
      price: json["price"],
      txnId: json["txnId"],
      convenienceFee: json["convenienceFee"],
      conveniencePercent: json["conveniencePercent"],
      advanceAmount: json["advanceAmount"],
      advancePercent: json["advancePercent"],
      promotionAmount: json["promotionAmount"],
      advStatus: json["advStatus"],
      isGolderHour: json["isGolderHour"],
      goldenHoursCharge: json["goldenHoursCharge"],
      overNightHikePercentage: json["overNightHikePercentage"],
      serviceId: json["serviceId"],
      dateString: DateTime.tryParse(json["dateString"] ?? ""),
      workerCount: json["workerCount"],
      workHours: json["workHours"],
      slotInterval: json["slotInterval"],
      aggCommissionPercent: json["aggCommissionPercent"],
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      bookingDate: json["bookingDate"],
      addressId: json["addressId"],
      assignedDate: json["assignedDate"],
      delete: json["delete"],
      paymentStatus: json["paymentStatus"],
      otp: json["otp"],
      workDone: json["workDone"],
      addlPromotionId: json["addlPromotionId"],
      addlPromotionAmount: json["addlPromotionAmount"],
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
        "price": price,
        "txnId": txnId,
        "convenienceFee": convenienceFee,
        "conveniencePercent": conveniencePercent,
        "advanceAmount": advanceAmount,
        "advancePercent": advancePercent,
        "promotionAmount": promotionAmount,
        "advStatus": advStatus,
        "isGolderHour": isGolderHour,
        "goldenHoursCharge": goldenHoursCharge,
        "overNightHikePercentage": overNightHikePercentage,
        "serviceId": serviceId,
        "dateString": dateString?.toIso8601String(),
        "workerCount": workerCount,
        "workHours": workHours,
        "slotInterval": slotInterval,
        "aggCommissionPercent": aggCommissionPercent,
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "bookingDate": bookingDate,
        "addressId": addressId,
        "assignedDate": assignedDate,
        "delete": delete,
        "paymentStatus": paymentStatus,
        "otp": otp,
        "workDone": workDone,
        "addlPromotionId": addlPromotionId,
        "addlPromotionAmount": addlPromotionAmount,
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

class JobData {
  JobData({
    required this.jobDate,
    required this.status,
    required this.userId,
    required this.servicePriceId,
    required this.assignedUserId,
    required this.price,
    required this.txnId,
    required this.convenienceFee,
    required this.conveniencePercent,
    required this.advanceAmount,
    required this.advancePercent,
    required this.advStatus,
    required this.isGolderHour,
    required this.goldenHoursCharge,
    required this.overNightHikePercentage,
    required this.serviceId,
    required this.dateString,
    required this.workerCount,
    required this.workHours,
    required this.slotInterval,
    required this.aggCommissionPercent,
  });

  final DateTime? jobDate;
  final String? status;
  final int? userId;
  final int? servicePriceId;
  final int? assignedUserId;
  final int? price;
  final String? txnId;
  final double? convenienceFee;
  final int? conveniencePercent;
  final double? advanceAmount;
  final int? advancePercent;
  final String? advStatus;
  final bool? isGolderHour;
  final int? goldenHoursCharge;
  final int? overNightHikePercentage;
  final int? serviceId;
  final DateTime? dateString;
  final int? workerCount;
  final int? workHours;
  final String? slotInterval;
  final int? aggCommissionPercent;

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      jobDate: DateTime.tryParse(json["jobDate"] ?? ""),
      status: json["status"],
      userId: json["userId"],
      servicePriceId: json["servicePriceId"],
      assignedUserId: json["assignedUserId"],
      price: json["price"],
      txnId: json["txnId"],
      convenienceFee: json["convenienceFee"],
      conveniencePercent: json["conveniencePercent"],
      advanceAmount: json["advanceAmount"],
      advancePercent: json["advancePercent"],
      advStatus: json["advStatus"],
      isGolderHour: json["isGolderHour"],
      goldenHoursCharge: json["goldenHoursCharge"],
      overNightHikePercentage: json["overNightHikePercentage"],
      serviceId: json["serviceId"],
      dateString: DateTime.tryParse(json["dateString"] ?? ""),
      workerCount: json["workerCount"],
      workHours: json["workHours"],
      slotInterval: json["slotInterval"],
      aggCommissionPercent: json["aggCommissionPercent"],
    );
  }

  Map<String, dynamic> toJson() => {
        "jobDate": jobDate?.toIso8601String(),
        "status": status,
        "userId": userId,
        "servicePriceId": servicePriceId,
        "assignedUserId": assignedUserId,
        "price": price,
        "txnId": txnId,
        "convenienceFee": convenienceFee,
        "conveniencePercent": conveniencePercent,
        "advanceAmount": advanceAmount,
        "advancePercent": advancePercent,
        "advStatus": advStatus,
        "isGolderHour": isGolderHour,
        "goldenHoursCharge": goldenHoursCharge,
        "overNightHikePercentage": overNightHikePercentage,
        "serviceId": serviceId,
        "dateString": dateString?.toIso8601String(),
        "workerCount": workerCount,
        "workHours": workHours,
        "slotInterval": slotInterval,
        "aggCommissionPercent": aggCommissionPercent,
      };
}

class UserData {
  UserData({
    required this.username,
    required this.email,
    required this.phone,
    required this.userGroupId,
    required this.userId,
  });

  final String? username;
  final String? email;
  final String? phone;
  final int? userGroupId;
  final int? userId;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json["username"],
      email: json["email"],
      phone: json["phone"],
      userGroupId: json["userGroupId"],
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "phone": phone,
        "userGroupId": userGroupId,
        "userId": userId,
      };
}
