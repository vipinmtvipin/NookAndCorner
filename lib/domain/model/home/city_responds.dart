class CityResponds {
  CityResponds({
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

  factory CityResponds.fromJson(Map<String, dynamic> json) {
    return CityResponds(
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

  static List<CityResponds> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CityResponds.fromJson(json)).toList();
  }
}
