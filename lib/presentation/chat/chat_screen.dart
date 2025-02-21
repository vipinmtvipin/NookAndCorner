import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/date_time_extensions.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/chat/message_data.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  MyBookingController myBookingController = Get.find<MyBookingController>();

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = GetIt.I<ChatService>();

  final ScrollController scrollController = ScrollController();

  final String currentUserType = 'user';

  final adminCommonMessage =
      "Thank you for reaching out! Our executive is currently busy, but you will receive a text back shortly. We appreciate your patience!";

  var initialAdminMessage = '';

  var userId = GetStorage().read(StorageKeys.userId).toString();
  var name = GetStorage().read(StorageKeys.username).toString();

  var chatViewLoad = false;

  var jobId = '';
  void _sendMessage() {
    final message = Message(
      from: 'user',
      message: _messageController.text,
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: [],
      name: name,
    );
    _chatService.sendMessage(
      userId,
      jobId,
      message,
    );
    _messageController.clear();
    final messageAdmin = Message(
      from: 'admin',
      message: adminCommonMessage,
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: [],
      name: "Admin",
    );
    _chatService.sendMessage(
      userId,
      jobId,
      messageAdmin,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi', '3gp'],
      allowCompression: true,
    );
    if (result != null) {
      final files = result.files;
      _showFilePreview(files);
    }
  }

  void _showFilePreview(List<PlatformFile> files) {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];

                      var fileType = 'image';
                      if (file.extension == 'jpg' ||
                          file.extension == 'jpeg' ||
                          file.extension == 'png') {
                        fileType = 'image';
                      } else {
                        fileType = 'video';
                      }

                      var fileTypes = files.map((file) {
                        if (file.extension == 'jpg' ||
                            file.extension == 'jpeg' ||
                            file.extension == 'png') {
                          return 'image';
                        } else {
                          return 'video';
                        }
                      }).toList();

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                String fileUrls = jsonEncode(
                                    files.map((e) => e.path).toList());
                                String fileTypeList = jsonEncode(fileTypes);
                                Get.toNamed(
                                  AppRoutes.chatPreviewScreen,
                                  arguments: {
                                    'fileUrls': fileUrls,
                                    'type': fileTypeList,
                                    'selectedIndex': index,
                                  },
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ConditionalWidget(
                                  condition: fileType == 'image',
                                  onFalse: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.antiAlias,
                                    child: Stack(
                                      children: [
                                        Assets.images.videoThum.image(
                                          fit: BoxFit.fill,
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          bottom: 0,
                                          right: 0,
                                          child: Icon(Icons.play_circle,
                                              color: Colors.black, size: 50),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.file(
                                      File(file.path!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onTap: () {
                                  setState(() {
                                    files.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NookCornerButton(
                    padding: const EdgeInsets.all(10),
                    expandedWidth: true,
                    type: NookCornerButtonType.filled,
                    onPressed: () async {
                      Navigator.pop(context);
                      await myBookingController.uploadFile(
                          files, adminCommonMessage, name);
                    },
                    text: 'Upload',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    chatViewLoad = false;
    setUpData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> setUpData() async {
    try {
      var selectedJob = myBookingController.selectedJob.value;

      jobId = selectedJob.jobId.toString();
      var subServiceName = selectedJob.servicePrice?.service?.category?.name;
      var jobDate = selectedJob.jobDate?.convertUtcToIst() ?? '';

      var name =
          GetStorage().read(StorageKeys.username).toString().toCapitalized;
      if (name.trim().isNullOrEmpty) {
        name = GetStorage().read(StorageKeys.email).toString().toCapitalized;
      }
      if (name.trim().isNullOrEmpty) {
        name = GetStorage().read(StorageKeys.mobile).toString();
      }
      initialAdminMessage =
          "Hi $name, \nWe noticed you have a booking with us. Here are the details:\nBooking ID: $jobId \nService Booked: $subServiceName \nService Date: $jobDate\nHow can I assist you with this booking today? I’m here to help with any questions or concerns you may have.";
    } catch (e) {
      initialAdminMessage =
          "Hi $name, \nWe noticed you have a booking with us.\nHow can I assist you with this booking today? I’m here to help with any questions or concerns you may have.";
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Chat Support",
              style: TextStyle(
                color: AppColors.white,
                letterSpacing: 3.0,
              ),
            )),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _chatService.getMessages(userId, jobId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data ?? [];

                  if (!chatViewLoad) {
                    final messageAdmin = Message(
                      from: 'admin',
                      message: initialAdminMessage,
                      timestamp: Timestamp.now(),
                      userId: userId,
                      fileUrl: [],
                      name: "Admin",
                    );
                    _chatService.sendMessage(userId, jobId, messageAdmin);
                    chatViewLoad = true;
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index];
                      final isCurrentUser = messageData.from == currentUserType;
                      final isFile =
                          messageData.fileUrl?.isNotNullOrEmpty ?? false;
                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConditionalWidget(
                          condition: !isFile,
                          onFalse: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: messageData.fileUrl!.length,
                              itemBuilder: (context, index) {
                                var fileUrl = messageData.fileUrl![index];
                                var fileType = 'image';
                                if (fileUrl.contains('jpg') ||
                                    fileUrl.contains('jpeg') ||
                                    fileUrl.contains('png')) {
                                  fileType = 'image';
                                } else {
                                  fileType = 'video';
                                }

                                return Hero(
                                  tag: fileUrl,
                                  child: ConditionalWidget(
                                    condition: fileType == 'image',
                                    onFalse: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.videoPlayerScreen,
                                            arguments: {
                                              'videoUrl': fileUrl,
                                              'type': ''
                                            });
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        clipBehavior: Clip.antiAlias,
                                        child: Stack(
                                          children: [
                                            Assets.images.videoThum.image(
                                              height: 180,
                                              width: 250,
                                              fit: BoxFit.fill,
                                            ),
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              bottom: 0,
                                              right: 0,
                                              child: Icon(Icons.play_circle,
                                                  color: Colors.black,
                                                  size: 50),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      clipBehavior: Clip.antiAlias,
                                      child: NetworkImageView(
                                        onTap: () {
                                          Get.toNamed(
                                              AppRoutes.fullScreenImageView,
                                              arguments: {
                                                'imageUrl': fileUrl,
                                                'type': ''
                                              });
                                        },
                                        borderRadius: 20,
                                        url: fileUrl,
                                        height: 250,
                                        width: 200,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 15.0),
                            padding: const EdgeInsets.all(12.0),
                            constraints: const BoxConstraints(maxWidth: 250),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue.withOpacity(0.6)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12.0),
                                topRight: const Radius.circular(12.0),
                                bottomLeft: Radius.circular(isCurrentUser
                                    ? 12.0
                                    : 0.0), // Rounded for user
                                bottomRight: Radius.circular(isCurrentUser
                                    ? 0.0
                                    : 12.0), // Rounded for admin
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 1),
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Text(
                              messageData.message ?? '',
                              style: TextStyle(
                                color:
                                    isCurrentUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    height: 0.4,
                    color: AppColors.whiteGray,
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _pickFile();
                          },
                          iconSize: 25,
                          icon: Icon(
                            Icons.attach_file_sharp,
                            color: AppColors.gray,
                          ),
                        ),
                        Flexible(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              contentPadding: const EdgeInsets.all(0),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _sendMessage();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 6),
                            child: Icon(
                              Icons.send,
                              size: 25,
                              color: AppColors.gray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
