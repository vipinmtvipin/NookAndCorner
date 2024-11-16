import 'dart:convert';

ReviewListResponds reviewsListRespondsFromJson(String str) =>
    ReviewListResponds.fromJson(json.decode(str));

class ReviewListResponds {
  ReviewListResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<ReviewData> data;

  factory ReviewListResponds.fromJson(Map<String, dynamic> json) {
    return ReviewListResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<ReviewData>.from(
              json["data"]!.map((x) => ReviewData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
      };
}

class ReviewData {
  ReviewData({
    required this.ratingId,
    required this.comment,
    required this.rating,
    required this.status,
    required this.userId,
    required this.jobId,
    required this.delete,
    required this.createdAt,
    required this.updatedAt,
    required this.job,
    required this.user,
  });

  final int? ratingId;
  final String? comment;
  final String? rating;
  final String? status;
  final int? userId;
  final int? jobId;
  final dynamic delete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Job? job;
  final User? user;

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      ratingId: json["ratingId"],
      comment: json["comment"],
      rating: json["rating"],
      status: json["status"],
      userId: json["userId"],
      jobId: json["jobId"],
      delete: json["delete"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      job: json["job"] == null ? null : Job.fromJson(json["job"]),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "ratingId": ratingId,
        "comment": comment,
        "rating": rating,
        "status": status,
        "userId": userId,
        "jobId": jobId,
        "delete": delete,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "job": job?.toJson(),
        "user": user?.toJson(),
      };
}

class Job {
  Job({
    required this.jobId,
    required this.jobDate,
    required this.status,
    required this.userId,
    required this.servicePriceId,
    required this.bookingDate,
    required this.addressId,
    required this.assignedUserId,
    required this.assignedDate,
    required this.delete,
    required this.paymentStatus,
    required this.otp,
    required this.txnId,
    required this.workDone,
    required this.promotionId,
    required this.promotionAmount,
    required this.addlPromotionId,
    required this.addlPromotionAmount,
    required this.promotionStatus,
    required this.price,
    required this.addonId,
    required this.convenienceFee,
    required this.conveniencePercent,
    required this.advanceAmount,
    required this.advancePercent,
    required this.advStatus,
    required this.refundStatus,
    required this.cancelledAt,
    required this.completedAt,
    required this.refundAmount,
    required this.isGolderHour,
    required this.goldenHoursCharge,
    required this.overNightHikePercentage,
    required this.startOtp,
    required this.startTime,
    required this.endTime,
    required this.dateString,
    required this.slotInterval,
    required this.serviceId,
    required this.workerCount,
    required this.workHours,
    required this.aggCommissionPercent,
    required this.refundRetryCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? jobId;
  final DateTime? jobDate;
  final String? status;
  final int? userId;
  final int? servicePriceId;
  final dynamic bookingDate;
  final int? addressId;
  final int? assignedUserId;
  final dynamic assignedDate;
  final dynamic delete;
  final String? paymentStatus;
  final String? otp;
  final String? txnId;
  final String? workDone;
  final int? promotionId;
  final double? promotionAmount;
  final dynamic addlPromotionId;
  final dynamic addlPromotionAmount;
  final dynamic promotionStatus;
  final double? price;
  final dynamic addonId;
  final double? convenienceFee;
  final String? conveniencePercent;
  final double? advanceAmount;
  final String? advancePercent;
  final String? advStatus;
  final dynamic refundStatus;
  final dynamic cancelledAt;
  final DateTime? completedAt;
  final dynamic refundAmount;
  final bool? isGolderHour;
  final int? goldenHoursCharge;
  final int? overNightHikePercentage;
  final String? startOtp;
  final DateTime? startTime;
  final dynamic endTime;
  final DateTime? dateString;
  final String? slotInterval;
  final int? serviceId;
  final String? workerCount;
  final String? workHours;
  final int? aggCommissionPercent;
  final int? refundRetryCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json["jobId"],
      jobDate: DateTime.tryParse(json["jobDate"] ?? ""),
      status: json["status"],
      userId: json["userId"],
      servicePriceId: json["servicePriceId"],
      bookingDate: json["bookingDate"],
      addressId: json["addressId"],
      assignedUserId: json["assignedUserId"],
      assignedDate: json["assignedDate"],
      delete: json["delete"],
      paymentStatus: json["paymentStatus"],
      otp: json["otp"],
      txnId: json["txnId"],
      workDone: json["workDone"],
      promotionId: json["promotionId"],
      promotionAmount: json["promotionAmount"],
      addlPromotionId: json["addlPromotionId"],
      addlPromotionAmount: json["addlPromotionAmount"],
      promotionStatus: json["promotionStatus"],
      price: json["price"],
      addonId: json["addonId"],
      convenienceFee: json["convenienceFee"],
      conveniencePercent: json["conveniencePercent"],
      advanceAmount: json["advanceAmount"],
      advancePercent: json["advancePercent"],
      advStatus: json["advStatus"],
      refundStatus: json["refundStatus"],
      cancelledAt: json["cancelledAt"],
      completedAt: DateTime.tryParse(json["completedAt"] ?? ""),
      refundAmount: json["refundAmount"],
      isGolderHour: json["isGolderHour"],
      goldenHoursCharge: json["goldenHoursCharge"],
      overNightHikePercentage: json["overNightHikePercentage"],
      startOtp: json["startOtp"],
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
      endTime: json["endTime"],
      dateString: DateTime.tryParse(json["dateString"] ?? ""),
      slotInterval: json["slotInterval"],
      serviceId: json["serviceId"],
      workerCount: json["workerCount"],
      workHours: json["workHours"],
      aggCommissionPercent: json["aggCommissionPercent"],
      refundRetryCount: json["refundRetryCount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "jobId": jobId,
        "jobDate": jobDate?.toIso8601String(),
        "status": status,
        "userId": userId,
        "servicePriceId": servicePriceId,
        "bookingDate": bookingDate,
        "addressId": addressId,
        "assignedUserId": assignedUserId,
        "assignedDate": assignedDate,
        "delete": delete,
        "paymentStatus": paymentStatus,
        "otp": otp,
        "txnId": txnId,
        "workDone": workDone,
        "promotionId": promotionId,
        "promotionAmount": promotionAmount,
        "addlPromotionId": addlPromotionId,
        "addlPromotionAmount": addlPromotionAmount,
        "promotionStatus": promotionStatus,
        "price": price,
        "addonId": addonId,
        "convenienceFee": convenienceFee,
        "conveniencePercent": conveniencePercent,
        "advanceAmount": advanceAmount,
        "advancePercent": advancePercent,
        "advStatus": advStatus,
        "refundStatus": refundStatus,
        "cancelledAt": cancelledAt,
        "completedAt": completedAt?.toIso8601String(),
        "refundAmount": refundAmount,
        "isGolderHour": isGolderHour,
        "goldenHoursCharge": goldenHoursCharge,
        "overNightHikePercentage": overNightHikePercentage,
        "startOtp": startOtp,
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime,
        "dateString": dateString?.toIso8601String(),
        "slotInterval": slotInterval,
        "serviceId": serviceId,
        "workerCount": workerCount,
        "workHours": workHours,
        "aggCommissionPercent": aggCommissionPercent,
        "refundRetryCount": refundRetryCount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class User {
  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.aadhaarCardNum,
    required this.delete,
    required this.status,
    required this.userGroupId,
    required this.primaryAddressId,
    required this.otp,
    required this.panCardNum,
    required this.ifscCode,
    required this.accountNum,
    required this.blackListMessage,
    required this.blackList,
  });

  final int? userId;
  final String? username;
  final String? email;
  final String? phone;
  final dynamic aadhaarCardNum;
  final dynamic delete;
  final dynamic status;
  final int? userGroupId;
  final int? primaryAddressId;
  final String? otp;
  final dynamic panCardNum;
  final dynamic ifscCode;
  final dynamic accountNum;
  final dynamic blackListMessage;
  final bool? blackList;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"],
      username: json["username"],
      email: json["email"],
      phone: json["phone"],
      aadhaarCardNum: json["aadhaarCardNum"],
      delete: json["delete"],
      status: json["status"],
      userGroupId: json["userGroupId"],
      primaryAddressId: json["primaryAddressId"],
      otp: json["otp"],
      panCardNum: json["panCardNum"],
      ifscCode: json["ifscCode"],
      accountNum: json["accountNum"],
      blackListMessage: json["blackListMessage"],
      blackList: json["blackList"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "email": email,
        "phone": phone,
        "aadhaarCardNum": aadhaarCardNum,
        "delete": delete,
        "status": status,
        "userGroupId": userGroupId,
        "primaryAddressId": primaryAddressId,
        "otp": otp,
        "panCardNum": panCardNum,
        "ifscCode": ifscCode,
        "accountNum": accountNum,
        "blackListMessage": blackListMessage,
        "blackList": blackList,
      };
}
