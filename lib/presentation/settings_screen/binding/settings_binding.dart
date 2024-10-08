import 'package:customerapp/presentation/settings_screen/controller/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
