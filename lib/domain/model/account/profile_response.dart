import 'dart:convert';

ProfileResponse profileListRespondsFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

class ProfileResponse {
  ProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final ProfileData? data;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class ProfileData {
  ProfileData({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
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
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.primaryAddress,
    this.accessToken = '',
  });

  final int? userId;
  final dynamic username;
  final String? email;
  final String? phone;
  final String? password;
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
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PrimaryAddress? primaryAddress;
  String accessToken;

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId: json["userId"],
      username: json["username"],
      email: json["email"],
      phone: json["phone"],
      password: json["password"],
      aadhaarCardNum: json["aadhaarCardNum"],
      delete: json["delete"],
      status: json["status"],
      userGroupId: json["userGroupId"],
      primaryAddressId: json["primaryAddressId"] is String
          ? int.tryParse(json["primaryAddressId"])
          : json["primaryAddressId"],
      otp: json["otp"],
      panCardNum: json["panCardNum"],
      ifscCode: json["ifscCode"],
      accountNum: json["accountNum"],
      blackListMessage: json["blackListMessage"],
      blackList: json["blackList"],
      deletedAt: json["deletedAt"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      primaryAddress: json["primaryAddress"] == null
          ? null
          : PrimaryAddress.fromJson(json["primaryAddress"]),
      accessToken: json["accessToken"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password,
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
        "deletedAt": deletedAt,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "primaryAddress": primaryAddress?.toJson(),
        "accessToken": accessToken,
      };

  static ProfileData empty() {
    return ProfileData(
      userId: 0,
      username: "",
      email: "",
      phone: "",
      password: "",
      aadhaarCardNum: "",
      delete: "",
      status: "",
      userGroupId: 0,
      primaryAddressId: 0,
      otp: "",
      panCardNum: "",
      ifscCode: "",
      accountNum: "",
      blackListMessage: "",
      blackList: false,
      deletedAt: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryAddress: null,
      accessToken: "",
    );
  }
}

class PrimaryAddress {
  PrimaryAddress({
    required this.addressId,
    required this.name,
    required this.addresslineOne,
    required this.addresslineTwo,
    required this.addressType,
    required this.location,
    required this.lat,
    required this.lng,
    required this.userId,
    required this.delete,
    required this.addressName,
    required this.address,
    required this.cityId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? addressId;
  final dynamic name;
  final String? addresslineOne;
  final String? addresslineTwo;
  final String? addressType;
  final String? location;
  final String? lat;
  final String? lng;
  final int? userId;
  final dynamic delete;
  final dynamic addressName;
  final dynamic address;
  final int? cityId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PrimaryAddress.fromJson(Map<String, dynamic> json) {
    return PrimaryAddress(
      addressId: json["addressId"],
      name: json["name"],
      addresslineOne: json["addresslineOne"],
      addresslineTwo: json["addresslineTwo"],
      addressType: json["addressType"],
      location: json["location"],
      lat: json["lat"],
      lng: json["lng"],
      userId: json["userId"],
      delete: json["delete"],
      addressName: json["addressName"],
      address: json["address"],
      cityId: json["cityId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "addressId": addressId,
        "name": name,
        "addresslineOne": addresslineOne,
        "addresslineTwo": addresslineTwo,
        "addressType": addressType,
        "location": location,
        "lat": lat,
        "lng": lng,
        "userId": userId,
        "delete": delete,
        "addressName": addressName,
        "address": address,
        "cityId": cityId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  static PrimaryAddress empty() {
    return PrimaryAddress(
      addressId: 0,
      name: "",
      addresslineOne: "",
      addresslineTwo: "",
      addressType: "",
      location: "",
      lat: "",
      lng: "",
      userId: 0,
      delete: "",
      addressName: "",
      address: "",
      cityId: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
