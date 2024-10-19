class JobRequest {
  JobRequest({
    required this.addOns,
    required this.advanceAmount,
    required this.advancePercent,
    required this.cityId,
    required this.convenienceFee,
    required this.conveniencePercent,
    required this.email,
    required this.goldenHoursCharge,
    required this.isGolderHour,
    required this.jobDate,
    required this.jobDateOnly,
    required this.name,
    required this.overNightHikePercentage,
    required this.phoneNumber,
    required this.price,
    this.promotionAmount,
    this.promotionId,
    this.promotionStatus,
    required this.serviceId,
    required this.supervisors,
    this.userId,
  });

  final List<AddOnAdd> addOns;
  final String? advanceAmount;
  final String? advancePercent;
  final int? cityId;
  final String? convenienceFee;
  final String? conveniencePercent;
  final String? email;
  final String? goldenHoursCharge;
  final bool? isGolderHour;
  final DateTime? jobDate;
  final DateTime? jobDateOnly;
  final String? name;
  final String? overNightHikePercentage;
  final String? phoneNumber;
  final String? price;
  final String? promotionAmount;
  final String? promotionId;
  final String? promotionStatus;
  final String? serviceId;
  final List<int> supervisors;
  final String? userId;

  JobRequest copyWith({
    List<AddOnAdd>? addOns,
    String? advanceAmount,
    String? advancePercent,
    int? cityId,
    String? convenienceFee,
    String? conveniencePercent,
    String? email,
    String? goldenHoursCharge,
    bool? isGolderHour,
    DateTime? jobDate,
    DateTime? jobDateOnly,
    String? name,
    String? overNightHikePercentage,
    String? phoneNumber,
    String? price,
    String? promotionAmount,
    String? promotionId,
    String? promotionStatus,
    String? serviceId,
    List<int>? supervisors,
    String? userId,
  }) {
    return JobRequest(
      addOns: addOns ?? this.addOns,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      advancePercent: advancePercent ?? this.advancePercent,
      cityId: cityId ?? this.cityId,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      conveniencePercent: conveniencePercent ?? this.conveniencePercent,
      email: email ?? this.email,
      goldenHoursCharge: goldenHoursCharge ?? this.goldenHoursCharge,
      isGolderHour: isGolderHour ?? this.isGolderHour,
      jobDate: jobDate ?? this.jobDate,
      jobDateOnly: jobDateOnly ?? this.jobDateOnly,
      name: name ?? this.name,
      overNightHikePercentage:
          overNightHikePercentage ?? this.overNightHikePercentage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      price: price ?? this.price,
      promotionAmount: promotionAmount ?? this.promotionAmount,
      promotionId: promotionId ?? this.promotionId,
      promotionStatus: promotionStatus ?? this.promotionStatus,
      serviceId: serviceId ?? this.serviceId,
      supervisors: supervisors ?? this.supervisors,
      userId: userId ?? this.userId,
    );
  }

  factory JobRequest.fromJson(Map<String, dynamic> json) {
    return JobRequest(
      addOns: json["addOns"] == null
          ? []
          : List<AddOnAdd>.from(
              json["addOns"]!.map((x) => AddOnAdd.fromJson(x))),
      advanceAmount: json["advanceAmount"],
      advancePercent: json["advancePercent"],
      cityId: json["cityId"],
      convenienceFee: json["convenienceFee"],
      conveniencePercent: json["conveniencePercent"],
      email: json["email"],
      goldenHoursCharge: json["goldenHoursCharge"],
      isGolderHour: json["isGolderHour"],
      jobDate: DateTime.tryParse(json["jobDate"] ?? ""),
      jobDateOnly: DateTime.tryParse(json["jobDateOnly"] ?? ""),
      name: json["name"],
      overNightHikePercentage: json["overNightHikePercentage"],
      phoneNumber: json["phoneNumber"],
      price: json["price"],
      promotionAmount: json["promotionAmount"],
      promotionId: json["promotionId"],
      promotionStatus: json["promotionStatus"],
      serviceId: json["serviceId"],
      supervisors: json["supervisors"] == null
          ? []
          : List<int>.from(json["supervisors"]!.map((x) => x)),
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "addOns": addOns.map((x) => x.toJson()).toList(),
        "advanceAmount": advanceAmount,
        "advancePercent": advancePercent,
        "cityId": cityId,
        "convenienceFee": convenienceFee,
        "conveniencePercent": conveniencePercent,
        "email": email,
        "goldenHoursCharge": goldenHoursCharge,
        "isGolderHour": isGolderHour,
        "jobDate": jobDate?.toIso8601String(),
        "jobDateOnly": jobDateOnly?.toIso8601String(),
        "name": name,
        "overNightHikePercentage": overNightHikePercentage,
        "phoneNumber": phoneNumber,
        "price": price,
        "promotionAmount": promotionAmount,
        "promotionId": promotionId,
        "promotionStatus": promotionStatus,
        "serviceId": serviceId,
        "supervisors": supervisors.map((x) => x).toList(),
        "userId": userId,
      };

  @override
  String toString() {
    return "$addOns, $advanceAmount, $advancePercent, $cityId, $convenienceFee, $conveniencePercent, $email, $goldenHoursCharge, $isGolderHour, $jobDate, $jobDateOnly, $name, $overNightHikePercentage, $phoneNumber, $price, $promotionAmount, $promotionId, $promotionStatus, $serviceId, $supervisors, $userId, ";
  }
}

class AddOnAdd {
  AddOnAdd({
    required this.addonId,
    required this.addonPrice,
    required this.quantity,
    required this.serviceId,
  });

  final int? addonId;
  final String? addonPrice;
  final int? quantity;
  final int? serviceId;

  AddOnAdd copyWith({
    int? addonId,
    String? addonPrice,
    int? quantity = 1,
    int? serviceId,
  }) {
    return AddOnAdd(
      addonId: addonId ?? this.addonId,
      addonPrice: addonPrice ?? this.addonPrice,
      quantity: quantity ?? this.quantity,
      serviceId: serviceId ?? this.serviceId,
    );
  }

  factory AddOnAdd.fromJson(Map<String, dynamic> json) {
    return AddOnAdd(
      addonId: json["addonId"],
      addonPrice: json["addonPrice"],
      quantity: json["quantity"],
      serviceId: json["serviceId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "addonId": addonId,
        "addonPrice": addonPrice,
        "quantity": quantity,
        "serviceId": serviceId,
      };

  @override
  String toString() {
    return "$addonId, $addonPrice, $quantity, $serviceId, ";
  }
}
