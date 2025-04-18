import 'dart:convert';

TimeSlotResponds timeSlotRespondsFromJson(String str) =>
    TimeSlotResponds.fromJson(json.decode(str));

class TimeSlotResponds {
  TimeSlotResponds({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final List<TimeSlotData> data;

  factory TimeSlotResponds.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponds(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<TimeSlotData>.from(
              json["data"]!.map((x) => TimeSlotData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class TimeSlotData {
  TimeSlotData({
    required this.slotStart,
    required this.supervisors,
    this.isSelected,
  });

  final bool? isSelected;
  final DateTime? slotStart;
  final List<int>? supervisors;

  TimeSlotData copyWith({
    bool? isSelected,
    DateTime? slotStart,
    List<int>? supervisors,
  }) {
    return TimeSlotData(
      slotStart: slotStart ?? this.slotStart,
      supervisors: supervisors ?? this.supervisors,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory TimeSlotData.fromJson(Map<String, dynamic> json) {
    return TimeSlotData(
      slotStart: DateTime.tryParse(json["slot_start"] ?? ""),
      isSelected: false,
      supervisors: json["supervisors"] == null
          ? []
          : List<int>.from(json["supervisors"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "slot_start": slotStart?.toIso8601String(),
        "supervisors": supervisors?.map((x) => x).toList(),
      };

  static empty() {
    return TimeSlotData(
      slotStart: DateTime.now(),
      supervisors: [],
      isSelected: false,
    );
  }
}
