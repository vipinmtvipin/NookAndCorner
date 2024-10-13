import 'dart:convert';

ServiceDetailsResponds serviceRespondsFromJson(String str) =>
    ServiceDetailsResponds.fromJson(json.decode(str));

class ServiceDetailsResponds {
  ServiceDetailsResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<ServiceData> data;

  factory ServiceDetailsResponds.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<ServiceData>.from(
              json["data"]!.map((x) => ServiceData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class ServiceData {
  ServiceData({
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
    required this.tags,
  });

  ServiceData.empty()
      : servId = 0,
        name = '',
        description = '',
        logo = '',
        price = '',
        delete = null,
        minNoEmployees = 0,
        maxNoEmployees = 0,
        minWorkHours = 0,
        maxWorkHours = 0,
        categoryId = 0,
        defaultAssignedUserId = null,
        status = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        tags = [];

  final int? servId;
  final String? name;
  final String? description;
  final String? logo;
  final String? price;
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
  final List<Tag> tags;

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      servId: json["serv_id"],
      name: json["name"],
      description: json["description"],
      logo: json["logo"],
      price: json["price"],
      delete: json["delete"],
      minNoEmployees: json["minNoEmployees"],
      maxNoEmployees: json["maxNoEmployees"],
      minWorkHours: json["minWorkHours"],
      maxWorkHours: json["maxWorkHours"],
      categoryId: json["categoryId"],
      defaultAssignedUserId: json["defaultAssignedUserId"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      tags: json["tags"] == null
          ? []
          : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
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
        "tags": tags.map((x) => x?.toJson()).toList(),
      };
}

class Tag {
  Tag({
    required this.id,
    required this.tagId,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryTag,
  });

  final int? id;
  final int? tagId;
  final int? serviceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryTag? categoryTag;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      tagId: json["tagId"],
      serviceId: json["serviceId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      categoryTag: json["categoryTag"] == null
          ? null
          : CategoryTag.fromJson(json["categoryTag"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "tagId": tagId,
        "serviceId": serviceId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "categoryTag": categoryTag?.toJson(),
      };
}

class CategoryTag {
  CategoryTag({
    required this.catTagId,
    required this.categoryTag,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? catTagId;
  final String? categoryTag;
  final String? status;
  final dynamic deleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CategoryTag.fromJson(Map<String, dynamic> json) {
    return CategoryTag(
      catTagId: json["catTagId"],
      categoryTag: json["categoryTag"],
      status: json["status"],
      deleted: json["deleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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
