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
  final Data? data;

  factory ReviewListResponds.fromJson(Map<String, dynamic> json) {
    return ReviewListResponds(
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
}

class Data {
  Data({
    required this.rows,
    required this.count,
  });

  final List<ReviewData> rows;
  final int? count;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      rows: json["rows"] == null
          ? []
          : List<ReviewData>.from(
              json["rows"]!.map((x) => ReviewData.fromJson(x))),
      count: json["count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rows": rows.map((x) => x.toJson()).toList(),
        "count": count,
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
        "user": user?.toJson(),
      };
}

class User {
  User({
    required this.username,
    required this.email,
  });

  final String? username;
  final String? email;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
      };
}
