import 'package:customerapp/presentation/my_booking_screen/controller/mybooking_controller.dart';
import 'package:get/get.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyBookingController());
  }
}
