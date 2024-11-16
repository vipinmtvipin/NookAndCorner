class ContactRequest {
  String? email;
  String? message;
  String? name;
  String? phone;

  ContactRequest({
    this.email,
    this.message,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['message'] = message;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}
