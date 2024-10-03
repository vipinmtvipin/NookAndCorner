import 'package:customerapp/data/network/apis_iml/auth_repository_iml.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/login/login_use_case.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepositoryIml>()));
  }
}
