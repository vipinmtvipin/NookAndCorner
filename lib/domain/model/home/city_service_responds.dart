class CityServiceResponds {
  CityServiceResponds({
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

  factory CityServiceResponds.fromJson(Map<String, dynamic> json) {
    return CityServiceResponds(
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

  static List<CityServiceResponds> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CityServiceResponds.fromJson(json)).toList();
  }
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
