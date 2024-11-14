import 'dart:convert';

AddressResponds addressListRespondsFromJson(String str) =>
    AddressResponds.fromJson(json.decode(str));

class AddressResponds {
  AddressResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<AddressData> data;

  factory AddressResponds.fromJson(Map<String, dynamic> json) {
    return AddressResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<AddressData>.from(
              json["data"]!.map((x) => AddressData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
      };
}

class AddressData {
  AddressData({
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

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
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
}
