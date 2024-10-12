import 'package:customerapp/presentation/summery_screen/controller/summery_controller.dart';
import 'package:get/get.dart';

class SummeryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SummeryController());
  }
}
