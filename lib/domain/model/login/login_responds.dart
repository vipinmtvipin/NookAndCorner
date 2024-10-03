import 'dart:convert';

LoginResponds loginRespondsFromJson(String str) =>
    LoginResponds.fromJson(json.decode(str));

String loginRespondsToJson(LoginResponds data) => json.encode(data.toJson());

class LoginResponds {
  LoginResponds({
    this.statusCode,
    this.message,
    this.error,
    this.success = false,
    this.accessToken,
    this.userInfo,
  });

  final int? statusCode;
  final String? message;
  final String? error;
  final bool? success;
  final String? accessToken;
  final UserInfo? userInfo;

  factory LoginResponds.fromJson(Map<String, dynamic> json) {
    return LoginResponds(
      statusCode: json["statusCode"],
      message: json["message"],
      error: json["error"],
      success: json["success"],
      accessToken: json["access_token"],
      userInfo:
          json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "error": error,
        "success": success,
        "access_token": accessToken,
        "userInfo": userInfo?.toJson(),
      };
}

class UserInfo {
  UserInfo({
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
    required this.userGroup,
    required this.primaryAddress,
  });

  final int? userId;
  final String? username;
  final String? email;
  final dynamic phone;
  final dynamic aadhaarCardNum;
  final dynamic delete;
  final dynamic status;
  final int? userGroupId;
  final int? primaryAddressId;
  final dynamic otp;
  final dynamic panCardNum;
  final dynamic ifscCode;
  final dynamic accountNum;
  final UserGroup? userGroup;
  final dynamic primaryAddress;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
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
      userGroup: json["userGroup"] == null
          ? null
          : UserGroup.fromJson(json["userGroup"]),
      primaryAddress: json["primaryAddress"],
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
        "userGroup": userGroup?.toJson(),
        "primaryAddress": primaryAddress,
      };
}

class UserGroup {
  UserGroup({
    required this.userGroupId,
    required this.name,
    required this.delete,
  });

  final int? userGroupId;
  final String? name;
  final dynamic delete;

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      userGroupId: json["userGroupId"],
      name: json["name"],
      delete: json["delete"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userGroupId": userGroupId,
        "name": name,
        "delete": delete,
      };
}
