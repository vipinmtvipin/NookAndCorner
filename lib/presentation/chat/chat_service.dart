import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/presentation/chat/message_data.dart';

class ChatService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String userId, Message message) async {
    var docRef = await _fireStore
        .collection('chat-staging')
        .doc("userId$userId")
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> getMessages(String userId) {
    return _fireStore
        .collection('chat-staging')
        .doc("userId$userId")
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }
}