import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenImageView extends StatefulWidget {
  const FullScreenImageView({
    super.key,
  });

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  var imageUrl = '';
  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments as Map<String, dynamic>;

    imageUrl = arguments['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: imageUrl,
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 5.0,
                child: NetworkImageView(
                  borderRadius: 10,
                  url: imageUrl,
                  fit: BoxFit.contain,
                ),
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
      ),
    );
  }
}
