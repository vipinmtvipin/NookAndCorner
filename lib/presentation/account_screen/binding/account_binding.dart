import 'package:get/get.dart';
import 'package:customerapp/presentation/account_screen/controller/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}
