import 'dart:convert';

CommonResponds commonRespondsFromJson(String str) =>
    CommonResponds.fromJson(json.decode(str));

String commonRespondsToJson(CommonResponds data) => json.encode(data.toJson());

class CommonResponds {
  CommonResponds({
    required this.success,
    required this.message,
  });

  final bool? success;
  final String? message;

  factory CommonResponds.fromJson(Map<String, dynamic> json) {
    return CommonResponds(
      success: json["success"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
