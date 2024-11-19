import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/presentation/chat/message_data.dart';
import 'package:customerapp/presentation/common_widgets/custom_icon_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = GetIt.I<ChatService>();

  final String currentUserType = 'user';

  final ScrollController _scrollController = ScrollController();

  var userId = GetStorage().read(StorageKeys.userId).toString();
  var name = GetStorage().read(StorageKeys.username).toString();

  void _sendMessage() {
    final message = Message(
      from: 'user',
      message: _messageController.text,
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: '',
      name: name,
    );
    _chatService.sendMessage(userId, message);
    _messageController.clear();
    final messageAdmin = Message(
      from: 'admin',
      message:
          "Thank you for reaching out! Our executive is currently busy, but you will receive a text back shortly. We appreciate your patience!",
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: '',
      name: "Admin",
    );
    _chatService.sendMessage(userId, messageAdmin);

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendFile(String fileUrl) {
    final message = Message(
      from: 'user',
      message: '',
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: fileUrl,
      name: name,
    );
    _chatService.sendMessage(userId, message);
    _messageController.clear();
    final messageAdmin = Message(
      from: 'admin',
      message:
          "Thank you for reaching out! Our executive is currently busy, but you will receive a text back shortly. We appreciate your patience!",
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: '',
      name: "Admin",
    );
    _chatService.sendMessage(userId, messageAdmin);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.first;
      //TODO call aws service to upload file

      _sendFile(file.path ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final isCurrentUser = messageData.from == currentUserType;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12.0),
                            topRight: const Radius.circular(12.0),
                            bottomLeft: Radius.circular(
                                isCurrentUser ? 12.0 : 0.0), // Rounded for user
                            bottomRight: Radius.circular(isCurrentUser
                                ? 0.0
                                : 12.0), // Rounded for admin
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: Text(
                          messageData.message ?? '',
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, -1),
                  blurRadius: 4.0,
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _pickFile();
                  },
                  iconSize: 25,
                  icon: Icon(
                    Icons.attach_file_sharp,
                    color: AppColors.white,
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                CustomIconButton(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 35,
                    width: 35,
                    onTap: () {
                      _sendMessage();
                    },
                    alignment: Alignment.topLeft,
                    shape: IconButtonShape.CircleBorder35,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.send,
                        size: 18,
                        color: AppColors.white,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
