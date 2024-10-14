import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/conditional_widget.dart';
import 'package:customerapp/presentation/common_widgets/title_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({
    super.key,
  });

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  var url = '';
  var title = '';
  WebViewController? controller;

  var isLoading = true;
  var isError = false;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments as Map<String, dynamic>;
    url = arguments['url'] ?? '';
    title = arguments['title'] ?? '';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          Logger.e('WebScreen-----', ': Loading progress: $progress');
        }, onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        }, onHttpError: (HttpResponseError error) {
          /*     setState(() {
            isError = true;
          });*/
        }, onWebResourceError: (WebResourceError error) {
          setState(() {
            isError = true;
          });
        }),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: !isLoading ? AppColors.white : AppColors.tinyGray,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              TitleBarWidget(title: title),
              const SizedBox(height: 25),
              Expanded(
                child: Stack(
                  children: [
                    ConditionalWidget(
                      condition: !isLoading,
                      onFalse: loadingWidget(),
                      child: ConditionalWidget(
                        condition: !isError,
                        onFalse: errorWidget(),
                        child: WebViewWidget(
                          controller: controller!,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: SpinKitFadingCube(
        color: AppColors.white,
        size: 60,
      ),
    );
  }

  Widget errorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * 0.2),
        Lottie.asset(
          Assets.lottie.nodata,
          alignment: Alignment.center,
          fit: BoxFit.contain,
          height: 200,
          width: 200,
          repeat: true,
        ),
        Text(
          'Failed to load the content',
          style: AppTextStyle.txtBold16,
        ),
      ],
    );
  }
}
