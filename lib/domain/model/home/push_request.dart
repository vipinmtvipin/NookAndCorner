class PushRequest {
  String? userId;
  String? userType;
  String? deviceToken;

  PushRequest({
    this.userId,
    this.userType,
    this.deviceToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['deviceToken'] = deviceToken;
    data['userType'] = userType;
    return data;
  }
}
