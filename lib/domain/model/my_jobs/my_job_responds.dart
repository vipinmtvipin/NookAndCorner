import 'dart:convert';

import 'package:customerapp/core/utils/common_util.dart';
import 'package:get_it/get_it.dart';

MyJobResponds myJobRespondsFromJson(String str) =>
    MyJobResponds.fromJson(json.decode(str));

String myJobRespondsToJson(MyJobResponds data) => json.encode(data.toJson());

class MyJobResponds {
  MyJobResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<MyJobData> data;

  factory MyJobResponds.fromJson(Map<String, dynamic> json) {
    return MyJobResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<MyJobData>.from(
              json["data"]!.map((x) => MyJobData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class MyJobData {
  MyJobData({
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
    required this.address,
    required this.promotion,
    required this.servicePrice,
    required this.user,
    required this.assignedUser,
    required this.orders,
    required this.rating,
  });

  final int? jobId;
  final DateTime? jobDate;
  final String? status;
  final int? userId;
  final int? servicePriceId;
  final dynamic bookingDate;
  final dynamic addressId;
  final int? assignedUserId;
  final dynamic assignedDate;
  final dynamic delete;
  final dynamic paymentStatus;
  final String? otp;
  final String? txnId;
  final dynamic workDone;
  final dynamic promotionId;
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
  final String? refundStatus;
  final DateTime? cancelledAt;
  final DateTime? completedAt;
  final double? refundAmount;
  final bool? isGolderHour;
  final double? goldenHoursCharge;
  final int? overNightHikePercentage;
  final dynamic startOtp;
  final dynamic startTime;
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
  final dynamic address;
  final dynamic promotion;
  final ServicePrice? servicePrice;
  final User? user;
  final User? assignedUser;
  final List<Order> orders;
  final Rating? rating;

  factory MyJobData.fromJson(Map<String, dynamic> json) {
    return MyJobData(
      jobId: json["jobId"],
      jobDate: DateTime.tryParse(
          json["jobDate"] ?? DateTime.now().toIso8601String()),
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
      promotionAmount: GetIt.I<CommonUtil>().toDouble(json["promotionAmount"]),
      addlPromotionId: json["addlPromotionId"],
      addlPromotionAmount: json["addlPromotionAmount"],
      promotionStatus: json["promotionStatus"],
      price: GetIt.I<CommonUtil>().toDouble(json["price"]),
      addonId: json["addonId"],
      convenienceFee: GetIt.I<CommonUtil>().toDouble(json["convenienceFee"]),
      conveniencePercent: json["conveniencePercent"],
      advanceAmount: GetIt.I<CommonUtil>().toDouble(json["advanceAmount"]),
      advancePercent: json["advancePercent"],
      advStatus: json["advStatus"],
      refundStatus: json["refundStatus"],
      cancelledAt: DateTime.tryParse(
          json["cancelledAt"] ?? DateTime.now().toIso8601String()),
      completedAt: DateTime.tryParse(
          json["completedAt"] ?? DateTime.now().toIso8601String()),
      refundAmount: GetIt.I<CommonUtil>().toDouble(json["refundAmount"]),
      isGolderHour: json["isGolderHour"],
      goldenHoursCharge:
          GetIt.I<CommonUtil>().toDouble(json["goldenHoursCharge"]),
      overNightHikePercentage: json["overNightHikePercentage"],
      startOtp: json["startOtp"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      dateString: DateTime.tryParse(json["dateString"] ?? ""),
      slotInterval: json["slotInterval"],
      serviceId: json["serviceId"],
      workerCount: json["workerCount"],
      workHours: json["workHours"],
      aggCommissionPercent: json["aggCommissionPercent"],
      refundRetryCount: json["refundRetryCount"],
      createdAt: DateTime.tryParse(
          json["createdAt"] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.tryParse(
          json["updatedAt"] ?? DateTime.now().toIso8601String()),
      address: json["address"],
      promotion: json["promotion"],
      servicePrice: json["servicePrice"] == null
          ? null
          : ServicePrice.fromJson(json["servicePrice"]),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      assignedUser: json["assignedUser"] == null
          ? null
          : User.fromJson(json["assignedUser"]),
      orders: json["orders"] == null
          ? []
          : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
      rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
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
        "cancelledAt": cancelledAt?.toIso8601String(),
        "completedAt": completedAt?.toIso8601String(),
        "refundAmount": refundAmount,
        "isGolderHour": isGolderHour,
        "goldenHoursCharge": goldenHoursCharge,
        "overNightHikePercentage": overNightHikePercentage,
        "startOtp": startOtp,
        "startTime": startTime,
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
        "address": address,
        "promotion": promotion,
        "servicePrice": servicePrice?.toJson(),
        "user": user?.toJson(),
        "assignedUser": assignedUser?.toJson(),
        "orders": orders.map((x) => x.toJson()).toList(),
        "rating": rating?.toJson(),
      };

  static MyJobData empty() {
    return MyJobData(
      jobId: 0,
      jobDate: DateTime.now(),
      status: "",
      userId: 0,
      servicePriceId: 0,
      bookingDate: "",
      addressId: 0,
      assignedUserId: 0,
      assignedDate: "",
      delete: "",
      paymentStatus: "",
      otp: "",
      txnId: "",
      workDone: "",
      promotionId: "",
      promotionAmount: 0.0,
      addlPromotionId: "",
      addlPromotionAmount: "",
      promotionStatus: "",
      price: 0.0,
      addonId: "",
      convenienceFee: 0.0,
      conveniencePercent: "",
      advanceAmount: 0.0,
      advancePercent: "",
      advStatus: "",
      refundStatus: "",
      cancelledAt: DateTime.now(),
      completedAt: DateTime.now(),
      refundAmount: 0.0,
      isGolderHour: false,
      goldenHoursCharge: 0.0,
      overNightHikePercentage: 0,
      startOtp: "",
      startTime: "",
      endTime: "",
      dateString: DateTime.now(),
      slotInterval: "",
      serviceId: 0,
      workerCount: "",
      workHours: "",
      aggCommissionPercent: 0,
      refundRetryCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      address: "",
      promotion: "",
      servicePrice: null,
      user: null,
      assignedUser: null,
      orders: [],
      rating: null,
    );
  }
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
  final String? aadhaarCardNum;
  final dynamic delete;
  final String? status;
  final int? userGroupId;
  final dynamic primaryAddressId;
  final String? otp;
  final String? panCardNum;
  final String? ifscCode;
  final String? accountNum;
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

class Order {
  Order({
    required this.orderId,
    required this.serviceId,
    required this.addonId,
    required this.addonPrice,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.jobId,
    required this.addon,
  });

  final int? orderId;
  final int? serviceId;
  final int? addonId;
  final double? addonPrice;
  final String? quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? jobId;
  final Addon? addon;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json["orderId"],
      serviceId: json["serviceId"],
      addonId: json["addonId"],
      addonPrice: GetIt.I<CommonUtil>().toDouble(json["addonPrice"]),
      quantity: json["quantity"],
      createdAt: DateTime.tryParse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.tryParse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
      jobId: json["jobId"],
      addon: json["addon"] == null ? null : Addon.fromJson(json["addon"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "serviceId": serviceId,
        "addonId": addonId,
        "addonPrice": addonPrice,
        "quantity": quantity,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "jobId": jobId,
        "addon": addon?.toJson(),
      };
}

class Addon {
  Addon({
    required this.addonId,
    required this.titile,
    required this.description,
    required this.price,
    required this.logo,
    required this.delete,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? addonId;
  final String? titile;
  final String? description;
  final double? price;
  final String? logo;
  final dynamic delete;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      addonId: json["addonId"],
      titile: json["titile"],
      description: json["description"],
      price: GetIt.I<CommonUtil>().toDouble(json["price"]),
      logo: json["logo"],
      delete: json["delete"],
      status: json["status"],
      createdAt: DateTime.tryParse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.tryParse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "addonId": addonId,
        "titile": titile,
        "description": description,
        "price": price,
        "logo": logo,
        "delete": delete,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ServicePrice {
  ServicePrice({
    required this.servicePriceId,
    required this.price,
    required this.maxNoEmployees,
    required this.cityId,
    required this.serviceId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  final int? servicePriceId;
  final double? price;
  final int? maxNoEmployees;
  final dynamic cityId;
  final int? serviceId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;

  factory ServicePrice.fromJson(Map<String, dynamic> json) {
    return ServicePrice(
      servicePriceId: json["servicePriceId"],
      price: GetIt.I<CommonUtil>().toDouble(json["price"]),
      maxNoEmployees: json["maxNoEmployees"],
      cityId: json["cityId"],
      serviceId: json["serviceId"],
      status: json["status"],
      createdAt: DateTime.tryParse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.tryParse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
      service:
          json["service"] == null ? null : Service.fromJson(json["service"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "servicePriceId": servicePriceId,
        "price": price,
        "maxNoEmployees": maxNoEmployees,
        "cityId": cityId,
        "serviceId": serviceId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "service": service?.toJson(),
      };
}

class Service {
  Service({
    required this.servId,
    required this.name,
    required this.description,
    required this.logo,
    required this.price,
    required this.delete,
    required this.minNoEmployees,
    required this.maxNoEmployees,
    required this.minWorkHours,
    required this.maxWorkHours,
    required this.categoryId,
    required this.defaultAssignedUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  final int? servId;
  final String? name;
  final String? description;
  final String? logo;
  final double? price;
  final dynamic delete;
  final int? minNoEmployees;
  final int? maxNoEmployees;
  final int? minWorkHours;
  final int? maxWorkHours;
  final int? categoryId;
  final dynamic defaultAssignedUserId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Category? category;

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      servId: json["serv_id"],
      name: json["name"],
      description: json["description"],
      logo: json["logo"],
      price: GetIt.I<CommonUtil>().toDouble(json["price"]),
      delete: json["delete"],
      minNoEmployees: json["minNoEmployees"],
      maxNoEmployees: json["maxNoEmployees"],
      minWorkHours: json["minWorkHours"],
      maxWorkHours: json["maxWorkHours"],
      categoryId: json["categoryId"],
      defaultAssignedUserId: json["defaultAssignedUserId"],
      status: json["status"],
      createdAt: DateTime.tryParse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.tryParse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
      category:
          json["category"] == null ? null : Category.fromJson(json["category"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "serv_id": servId,
        "name": name,
        "description": description,
        "logo": logo,
        "price": price,
        "delete": delete,
        "minNoEmployees": minNoEmployees,
        "maxNoEmployees": maxNoEmployees,
        "minWorkHours": minWorkHours,
        "maxWorkHours": maxWorkHours,
        "categoryId": categoryId,
        "defaultAssignedUserId": defaultAssignedUserId,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
      };
}

class Category {
  Category({
    required this.catid,
    required this.name,
    required this.description,
    required this.logo,
    required this.descriptionImageVertical,
    required this.descriptionImageHorizontal,
    required this.cityId,
    required this.delete,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? catid;
  final String? name;
  final String? description;
  final String? logo;
  final String? descriptionImageVertical;
  final String? descriptionImageHorizontal;
  final int? cityId;
  final dynamic delete;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catid: json["catid"],
      name: json["name"],
      description: json["description"],
      logo: json["logo"],
      descriptionImageVertical: json["descriptionImageVertical"],
      descriptionImageHorizontal: json["descriptionImageHorizontal"],
      cityId: json["cityId"],
      delete: json["delete"],
      status: json["status"],
      createdAt: DateTime.tryParse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.tryParse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "catid": catid,
        "name": name,
        "description": description,
        "logo": logo,
        "descriptionImageVertical": descriptionImageVertical,
        "descriptionImageHorizontal": descriptionImageHorizontal,
        "cityId": cityId,
        "delete": delete,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Rating {
  Rating({
    required this.ratingId,
    required this.comment,
    required this.rating,
    required this.status,
    required this.userId,
    required this.jobId,
    required this.delete,
    required this.createdAt,
    required this.updatedAt,
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

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      ratingId: json["ratingId"],
      comment: json["comment"],
      rating: json["rating"],
      status: json["status"],
      userId: json["userId"],
      jobId: json["jobId"],
      delete: json["delete"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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
      };
}
