import 'dart:convert';

LoginResponds loginRespondsFromJson(String str) =>
    LoginResponds.fromJson(json.decode(str));

String loginRespondsToJson(LoginResponds data) => json.encode(data.toJson());

class LoginResponds {
  LoginResponds({
    this.success,
    this.message,
    this.statusCode,
    this.error,
    this.data,
  });

  final bool? success;
  final String? message;
  final int? statusCode;
  final String? error;
  final LoginData? data;

  factory LoginResponds.fromJson(Map<String, dynamic> json) {
    return LoginResponds(
      success: json["success"],
      message: json["message"],
      statusCode: json["statusCode"],
      error: json["error"],
      data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "error": error,
        "data": data?.toJson(),
      };
}

class LoginData {
  LoginData({
    required this.accessToken,
    required this.user,
  });

  final String? accessToken;
  final User? user;

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json["accessToken"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user?.toJson(),
      };
}

class User {
  User({
    required this.userId,
    required this.phone,
    required this.userGroupId,
    required this.username,
    required this.email,
    required this.password,
    required this.aadhaarCardNum,
    required this.delete,
    required this.status,
    required this.primaryAddressId,
    required this.panCardNum,
    required this.ifscCode,
    required this.accountNum,
    required this.userGroup,
    required this.updatedAt,
    required this.createdAt,
  });

  final int? userId;
  final String? phone;
  final int? userGroupId;
  final dynamic username;
  final dynamic email;
  final dynamic password;
  final dynamic aadhaarCardNum;
  final dynamic delete;
  final dynamic status;
  final dynamic primaryAddressId;
  final dynamic panCardNum;
  final dynamic ifscCode;
  final dynamic accountNum;
  final UserGroup? userGroup;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"],
      phone: json["phone"],
      userGroupId: json["userGroupId"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      aadhaarCardNum: json["aadhaarCardNum"],
      delete: json["delete"],
      status: json["status"],
      primaryAddressId: json["primaryAddressId"],
      panCardNum: json["panCardNum"],
      ifscCode: json["ifscCode"],
      accountNum: json["accountNum"],
      userGroup: json["userGroup"] == null
          ? null
          : UserGroup.fromJson(json["userGroup"]),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "phone": phone,
        "userGroupId": userGroupId,
        "username": username,
        "email": email,
        "password": password,
        "aadhaarCardNum": aadhaarCardNum,
        "delete": delete,
        "status": status,
        "primaryAddressId": primaryAddressId,
        "panCardNum": panCardNum,
        "ifscCode": ifscCode,
        "accountNum": accountNum,
        "userGroup": userGroup?.toJson(),
        "updatedAt": updatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
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
