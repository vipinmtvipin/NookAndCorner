import 'package:customerapp/presentation/base_controller.dart';
import 'package:get/get.dart';

enum MyBookingStatus { scheduled, pending, cancelled, completed }

enum MyBookingState { loading, loaded, error }

class MyBookingController extends BaseController {
  var screenTitle = 'My Bookings';
  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    screenTitle = arguments['title'] ?? '';
  }
}
