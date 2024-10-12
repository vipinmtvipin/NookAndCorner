import 'dart:convert';

TagResponds tagRespondsFromJson(String str) =>
    TagResponds.fromJson(json.decode(str));

class TagResponds {
  TagResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<TagData> data;

  factory TagResponds.fromJson(Map<String, dynamic> json) {
    return TagResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<TagData>.from(json["data"]!.map((x) => TagData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class TagData {
  TagData({
    required this.catTagId,
    required this.categoryTag,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.isSelected,
  });

  final int? catTagId;
  final String? categoryTag;
  final String? status;
  final dynamic deleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isSelected;

  TagData copyWith({
    int? catTagId,
    String? categoryTag,
    String? status,
    dynamic deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSelected,
  }) {
    return TagData(
      catTagId: catTagId ?? this.catTagId,
      categoryTag: categoryTag ?? this.categoryTag,
      status: status ?? this.status,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory TagData.fromJson(Map<String, dynamic> json) {
    return TagData(
      catTagId: json["catTagId"],
      categoryTag: json["categoryTag"],
      status: json["status"],
      deleted: json["deleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() => {
        "catTagId": catTagId,
        "categoryTag": categoryTag,
        "status": status,
        "deleted": deleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
