import 'dart:convert';

CityResponds cityRespondsFromJson(String str) =>
    CityResponds.fromJson(json.decode(str));

String cityRespondsToJson(CityResponds data) => json.encode(data.toJson());

class CityResponds {
  CityResponds({
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
  final List<CityData>? data;

  factory CityResponds.fromJson(Map<String, dynamic> json) {
    return CityResponds(
      success: json["success"],
      message: json["message"],
      statusCode: json["statusCode"],
      error: json["error"],
      data: json["data"] == null
          ? []
          : List<CityData>.from(json["data"]!.map((x) => CityData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "error": error,
        "data": data?.map((x) => x?.toJson()).toList(),
      };
}

class CityData {
  CityData({
    this.cityId,
    this.cityName,
    this.location,
    this.image,
    this.east,
    this.west,
    this.south,
    this.north,
    this.delete,
    this.status,
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

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
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
      };

  static empty() {
    return CityData(
      cityId: 0,
      cityName: '',
      location: '',
      image: '',
      east: '',
      west: '',
      south: '',
      north: '',
      delete: '',
      status: '',
    );
  }
}
