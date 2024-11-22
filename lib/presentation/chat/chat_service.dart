import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/presentation/chat/message_data.dart';

class ChatService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(
    String userId,
    String jobId,
    Message message,
  ) async {
    var docRef = await _fireStore
        .collection(NetworkKeys.firebaseNode)
        .doc("userId$userId-Job$jobId")
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> getMessages(
    String userId,
    String jobId,
  ) {
    return _fireStore
        .collection(NetworkKeys.firebaseNode)
        .doc("userId$userId-Job$jobId")
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
  }
}
