import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late WebViewController webViewController;

  late String paymentUrl;
  late ServiceController serviceController;

  String paymentType = "";
  double amount = 0.0;
  String oderId = "";

  bool showLoader = true;
  int progress_count = 0;

  Future<void> _logEvent() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'visit_order_summary_proceed_to_checkout',
    );
  }

  @override
  void initState() {
    super.initState();
    _logEvent();
    final arguments = Get.arguments as Map<String, dynamic>;
    amount = arguments['paymentAmount'] ?? 0.0;
    oderId = arguments['orderID'] ?? '';
    paymentType = arguments['paymentType'] ?? '';

    if (paymentType == "Advance") {
      serviceController = Get.find<ServiceController>();
    }

    _initializePaymentUrl();

    Logger.e('WebScreen---1111--', ': Web URL------: $paymentUrl');
  }

  void _initializePaymentUrl() {
    String callbackUrl = paymentType == "Advance"
        ? NetworkKeys.ccaAdvCallbackUrl
        : NetworkKeys.ccaCallbackUrl;

    // Define parameters
    String plainTextPayload =
        "merchant_id=${NetworkKeys.ccaMerchantId}&order_id=$oderId&amount=$amount&currency=INR&redirect_url=$callbackUrl&cancel_url=${NetworkKeys.ccAvenueCancelUrl}&language=EN";
    String encRequest = encrypter(plainTextPayload, NetworkKeys.ccaWorkingKey);

    Logger.e('WebScreen-----', ': Web payload------: $plainTextPayload');

    // Construct the full URL
    paymentUrl =
        "${NetworkKeys.ccAvenueUrl}&encRequest=$encRequest&access_code=${NetworkKeys.ccaAccessCode}";

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            Logger.e('WebScreen-----', ': progress --: $progress');

            if (mounted) {
              setState(() {
                if (progress != 100) {
                  showLoader = true;
                }
                showLoader = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                showLoader = false;
              });
            }
          },
          onHttpError: (HttpResponseError error) {
            Logger.e('WebScreen-----',
                ': HttpResponseError error--: ${error.response.toString()}');
          },
          onWebResourceError: (WebResourceError error) {
            Logger.e('WebScreen-----',
                ': WebResourceError error--: ${error.description}');
            Logger.e('WebScreen-----',
                ': WebResourceError error--: ${error.errorCode}');
          },
          onNavigationRequest: (NavigationRequest request) {
            Logger.e(
                'WebScreen--2222---', ': NavigationRequest------: $paymentUrl');
            if (request.url.contains('status=Success')) {
              if (paymentType == "Advance") {
                serviceController.paymentStatus.value = PaymentStatus.success;
                Get.offAndToNamed(AppRoutes.paymentStatusScreen);
              } else {
                Get.back(result: true);
                Get.snackbar(
                  "Success",
                  "Payment Successful",
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(2),
                  borderRadius: 10,
                  shouldIconPulse: true,
                  icon: Icon(
                    Icons.check_circle,
                    color: AppColors.white,
                  ),
                  duration: Duration(seconds: 4),
                  backgroundColor: Colors.green,
                );
              }
            } else {
              //status=invalidOrderOrPayment
              //status=failed
              if (progress_count == 100) {
                if (paymentType == "Advance") {
                  serviceController.paymentStatus.value = PaymentStatus.failed;
                  Get.offAndToNamed(AppRoutes.paymentStatusScreen);
                } else {
                  Get.back(result: true);
                  Get.snackbar(
                    "Failed",
                    "Payment Failed, please try again!",
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(2),
                    borderRadius: 10,
                    shouldIconPulse: true,
                    icon: Icon(
                      Icons.error,
                      color: AppColors.white,
                    ),
                    duration: Duration(seconds: 4),
                    backgroundColor: Colors.red,
                  );
                }
              }
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange? url) {
            Logger.e('WebScreen-----', ': UrlChange------: ${url!.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  String encrypter(String plainText, String workingKey) {
    final keyHash = md5.convert(utf8.encode(workingKey)).bytes;
    final iv = encrypt.IV(Uint8List.fromList(List<int>.generate(16, (i) => i)));
    final encrypter = encrypt.Encrypter(encrypt.AES(
        encrypt.Key(Uint8List.fromList(keyHash)),
        mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base16;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'CC Avenue',
        style: TextStyle(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Stack(
          children: [
            WebViewWidget(
              controller: webViewController,
            ),
            Visibility(
              visible: showLoader,
              child: Positioned(
                  child: Center(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )),
              )),
            )
          ],
        ),
      ),
    );
  }
}
