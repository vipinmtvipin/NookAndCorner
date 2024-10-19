import 'dart:convert';

AddOnListResponds addonRespondsFromJson(String str) =>
    AddOnListResponds.fromJson(json.decode(str));

class AddOnListResponds {
  AddOnListResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final AddOnListData? data;

  AddOnListResponds copyWith({
    bool? success,
    String? message,
    AddOnListData? data,
  }) {
    return AddOnListResponds(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory AddOnListResponds.fromJson(Map<String, dynamic> json) {
    return AddOnListResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : AddOnListData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class AddOnListData {
  AddOnListData({
    required this.data,
    required this.count,
  });

  final List<AddOnData> data;
  final int? count;

  AddOnListData copyWith({
    List<AddOnData>? data,
    int? count,
  }) {
    return AddOnListData(
      data: data ?? this.data,
      count: count ?? this.count,
    );
  }

  factory AddOnListData.fromJson(Map<String, dynamic> json) {
    return AddOnListData(
      data: json["data"] == null
          ? []
          : List<AddOnData>.from(
              json["data"]!.map((x) => AddOnData.fromJson(x))),
      count: json["count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
        "count": count,
      };
}

class AddOnData {
  AddOnData({
    required this.addonId,
    required this.titile,
    required this.description,
    required this.price,
    required this.logo,
    required this.delete,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.addonService,
    this.quantity = 0,
  });

  final int? addonId;
  final String? titile;
  final String? description;
  final String? price;
  final String? logo;
  final dynamic delete;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AddonService> addonService;
  final int? quantity;

  AddOnData copyWith({
    int? addonId,
    String? titile,
    String? description,
    String? price = '0',
    String? logo,
    dynamic? delete,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AddonService>? addonService,
    int? quantity = 0,
  }) {
    return AddOnData(
      addonId: addonId ?? this.addonId,
      titile: titile ?? this.titile,
      description: description ?? this.description,
      price: price ?? this.price,
      logo: logo ?? this.logo,
      delete: delete ?? this.delete,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addonService: addonService ?? this.addonService,
      quantity: quantity ?? this.quantity,
    );
  }

  factory AddOnData.fromJson(Map<String, dynamic> json) {
    return AddOnData(
      addonId: json["addonId"],
      titile: json["titile"],
      description: json["description"],
      price: json["price"],
      logo: json["logo"],
      delete: json["delete"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      addonService: json["addonService"] == null
          ? []
          : List<AddonService>.from(
              json["addonService"]!.map((x) => AddonService.fromJson(x))),
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
        "addonService": addonService.map((x) => x.toJson()).toList(),
      };

  static empty() {
    return AddOnData(
      addonId: 0,
      titile: '',
      description: '',
      price: '0',
      logo: '',
      delete: '',
      status: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      addonService: [],
    );
  }
}

class AddonService {
  AddonService({
    required this.id,
    required this.subServiceId,
    required this.addonId,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  final int? id;
  final int? subServiceId;
  final int? addonId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Service? service;

  AddonService copyWith({
    int? id,
    int? subServiceId,
    int? addonId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Service? service,
  }) {
    return AddonService(
      id: id ?? this.id,
      subServiceId: subServiceId ?? this.subServiceId,
      addonId: addonId ?? this.addonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      service: service ?? this.service,
    );
  }

  factory AddonService.fromJson(Map<String, dynamic> json) {
    return AddonService(
      id: json["id"],
      subServiceId: json["subServiceId"],
      addonId: json["addonId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      service:
          json["service"] == null ? null : Service.fromJson(json["service"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "subServiceId": subServiceId,
        "addonId": addonId,
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
  final Category? category;

  Service copyWith({
    int? servId,
    String? name,
    String? description,
    String? logo,
    String? price,
    dynamic? delete,
    int? minNoEmployees,
    int? maxNoEmployees,
    int? minWorkHours,
    int? maxWorkHours,
    int? categoryId,
    dynamic? defaultAssignedUserId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Category? category,
  }) {
    return Service(
      servId: servId ?? this.servId,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      price: price ?? this.price,
      delete: delete ?? this.delete,
      minNoEmployees: minNoEmployees ?? this.minNoEmployees,
      maxNoEmployees: maxNoEmployees ?? this.maxNoEmployees,
      minWorkHours: minWorkHours ?? this.minWorkHours,
      maxWorkHours: maxWorkHours ?? this.maxWorkHours,
      categoryId: categoryId ?? this.categoryId,
      defaultAssignedUserId:
          defaultAssignedUserId ?? this.defaultAssignedUserId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
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
    required this.cityId,
    required this.delete,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
  });

  final int? catid;
  final String? name;
  final String? description;
  final String? logo;
  final int? cityId;
  final dynamic delete;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final City? city;

  Category copyWith({
    int? catid,
    String? name,
    String? description,
    String? logo,
    int? cityId,
    dynamic? delete,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    City? city,
  }) {
    return Category(
      catid: catid ?? this.catid,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      cityId: cityId ?? this.cityId,
      delete: delete ?? this.delete,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      city: city ?? this.city,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catid: json["catid"],
      name: json["name"],
      description: json["description"],
      logo: json["logo"],
      cityId: json["cityId"],
      delete: json["delete"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      city: json["city"] == null ? null : City.fromJson(json["city"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "catid": catid,
        "name": name,
        "description": description,
        "logo": logo,
        "cityId": cityId,
        "delete": delete,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "city": city?.toJson(),
      };
}

class City {
  City({
    required this.cityId,
    required this.cityName,
    required this.location,
    required this.image,
    required this.east,
    required this.west,
    required this.south,
    required this.north,
    required this.delete,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? cityId;
  final String? cityName;
  final String? location;
  final String? image;
  final String? east;
  final String? west;
  final String? south;
  final String? north;
  final dynamic delete;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  City copyWith({
    int? cityId,
    String? cityName,
    String? location,
    String? image,
    String? east,
    String? west,
    String? south,
    String? north,
    dynamic? delete,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return City(
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      location: location ?? this.location,
      image: image ?? this.image,
      east: east ?? this.east,
      west: west ?? this.west,
      south: south ?? this.south,
      north: north ?? this.north,
      delete: delete ?? this.delete,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json["cityId"],
      cityName: json["cityName"],
      location: json["location"],
      image: json["image"],
      east: json["east"],
      west: json["west"],
      south: json["south"],
      north: json["north"],
      delete: json["delete"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "cityId": cityId,
        "cityName": cityName,
        "location": location,
        "image": image,
        "east": east,
        "west": west,
        "south": south,
        "north": north,
        "delete": delete,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
