class LoginRequest {
  String? username;
  String? password;
  String? from;

  LoginRequest({
    this.username,
    this.password,
    this.from = 'mobile',
  });

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    from = json['from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (username != null) {
      data['username'] = username;
    }
    if (password != null) {
      data['password'] = password;
    }
    return data;
  }
}
