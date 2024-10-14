class AddressRequest {
  String? city;
  String? street;
  String? hoseFlat;
  String? addressType;
  String latitude;
  String longitude;

  AddressRequest(
      {this.city,
      this.street,
      this.hoseFlat,
      this.addressType,
      required this.latitude,
      required this.longitude});
}
