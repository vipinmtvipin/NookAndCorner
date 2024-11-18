class ProfileRequest {
  String? email;
  String? phone;
  String? username;
  String? userId;
  String? primaryAddressId;

  ProfileRequest({
    this.email,
    this.phone,
    this.username,
    this.userId,
    this.primaryAddressId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['phone'] = phone;
    data['username'] = username;
    data['userId'] = userId;
    data['primaryAddressId'] = primaryAddressId;
    return data;
  }
}
