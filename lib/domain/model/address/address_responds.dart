class AddressResponds {
  final String? status;

  AddressResponds({
    this.status,
  });

  factory AddressResponds.fromJson(Map<String, dynamic> json) {
    return AddressResponds(
      status: json['status'],
    );
  }
}
