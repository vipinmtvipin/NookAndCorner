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
  final JobInfoData? data;

  factory JobResponds.fromJson(Map<String, dynamic> json) {
    return JobResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : JobInfoData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };

  static JobResponds empty() {
    return JobResponds(success: false, message: '', data: null);
  }
}

class JobInfoData {
  JobInfoData({
    required this.jobData,
    required this.userData,
    required this.jobCreated,
  });

  final JobData? jobData;
  final UserData? userData;
  final JobCreated? jobCreated;

  factory JobInfoData.fromJson(Map<String, dynamic> json) {
    return JobInfoData(
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

  final String? refundRetryCount;
  final int? jobId;
  final DateTime? jobDate;
  final String? status;
  final int? userId;
  final int? servicePriceId;
  final int? assignedUserId;
  final int? promotionId;
  final double? price;
  final String? txnId;
  final int? convenienceFee;
  final String? conveniencePercent;
  final double? advanceAmount;
  final String? advancePercent;
  final double? promotionAmount;
  final String? advStatus;
  final bool? isGolderHour;
  final int? goldenHoursCharge;
  final int? overNightHikePercentage;
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

class JobData {
  JobData({
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
  });

  final DateTime? jobDate;
  final String? status;
  final int? userId;
  final int? servicePriceId;
  final int? assignedUserId;
  final int? promotionId;
  final double? price;
  final String? txnId;
  final int? convenienceFee;
  final String? conveniencePercent;
  final double? advanceAmount;
  final String? advancePercent;
  final double? promotionAmount;
  final String? advStatus;
  final bool? isGolderHour;
  final int? goldenHoursCharge;
  final String? overNightHikePercentage;
  final int? serviceId;
  final DateTime? dateString;
  final int? workerCount;
  final int? workHours;
  final String? slotInterval;

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
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
    );
  }

  Map<String, dynamic> toJson() => {
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
      };
}

class UserData {
  UserData({
    required this.username,
    required this.email,
    required this.phone,
    required this.userGroupId,
  });

  final String? username;
  final String? email;
  final String? phone;
  final int? userGroupId;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json["username"],
      email: json["email"],
      phone: json["phone"],
      userGroupId: json["userGroupId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "phone": phone,
        "userGroupId": userGroupId,
      };
}
