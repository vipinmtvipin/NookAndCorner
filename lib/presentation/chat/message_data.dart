import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String from;
  final String message;
  final List<String>? fileUrl;
  final Timestamp timestamp;
  final String? name;
  final String? userId;
  Message({
    required this.from,
    required this.message,
    this.fileUrl,
    required this.timestamp,
    this.name,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'message': message,
      'timestamp': timestamp,
      'userId': userId,
      'fileUrl': fileUrl,
      'name': name,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      from: map['from'] ?? '',
      message: map['message'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      timestamp:
          map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.now(),
      fileUrl: map['fileUrl'] is List ? List<String>.from(map['fileUrl']) : [],
    );
  }
}
