import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String from;
  final String message;
  final String? fileUrl;
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

  Map<String, dynamic> toMap() => {
        'from': from,
        'message': message,
        'fileUrl': fileUrl,
        'timestamp': timestamp,
        'name': name,
        'userId': userId,
      };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        from: map['from'],
        message: map['message'],
        fileUrl: map['fileUrl'],
        timestamp: map['timestamp'],
        name: map['name'],
        userId: map['userId'],
      );
}
