class AddressRequest {
  String? addresslineOne;
  String? addresslineTwo;
  String? location;
  String? addressType;
  String? lat;
  String? lng;
  String? userId;
  String? cityId;

  AddressRequest({
    this.addressType,
    this.addresslineOne,
    this.addresslineTwo,
    this.location,
    this.lat,
    this.lng,
    this.userId,
    this.cityId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addresslineOne'] = addresslineOne;
    data['addresslineTwo'] = addresslineTwo;
    data['location'] = location;
    data['addressType'] = addressType;
    data['lat'] = lat;
    data['lng'] = lng;
    data['userId'] = userId;
    data['cityId'] = cityId;
    return data;
  }

  @override
  String toString() {
    return 'AddressRequest{addresslineOne: $addresslineOne, addresslineTwo: $addresslineTwo, location: $location, addressType: $addressType, lat: $lat, lng: $lng}';
  }
}

class GetAddressRequest {
  String? userId;
  String? cityId;

  GetAddressRequest({
    this.userId,
    this.cityId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['cityId'] = cityId;
    return data;
  }
}
