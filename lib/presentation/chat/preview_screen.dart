import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({
    super.key,
  });

  @override
  PreviewScreenState createState() => PreviewScreenState();
}

class PreviewScreenState extends State<PreviewScreen> {
  List<String> fileUrls = [];

  List<String> types = [];

  late PageController _pageController;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments as Map<String, dynamic>;
    String fileData = Get.arguments['fileUrls'];
    int index = Get.arguments['selectedIndex'];

    fileUrls = List<String>.from(jsonDecode(fileData));
    types = List<String>.from(jsonDecode(arguments['type']));

    _pageController = PageController(initialPage: index);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: fileUrls.length,
            itemBuilder: (context, index) {
              final fileUrl = fileUrls[index];
              final type = types[index];
              if (type == 'video') {
                var videoFile = File(fileUrl);
                _videoPlayerController = VideoPlayerController.file(videoFile)
                  ..initialize().then((_) {
                    setState(() {
                      _chewieController = ChewieController(
                        videoPlayerController: _videoPlayerController,
                        autoPlay: true,
                        looping: false,
                      );
                    });
                  });

                return Stack(
                  children: [
                    Hero(
                      tag: fileUrl,
                      child: Center(
                        child: _chewieController != null &&
                                _chewieController!
                                    .videoPlayerController.value.isInitialized
                            ? Chewie(controller: _chewieController!)
                            : CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Hero(
                    tag: fileUrl,
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 1.0,
                      maxScale: 5.0,
                      child: Image.file(
                        File(fileUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }
}
