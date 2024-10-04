import 'package:customerapp/data/network/apis_iml/auth_repository_iml.dart';
import 'package:customerapp/domain/repositories/auth/auth_repository.dart';
import 'package:customerapp/domain/usecases/forget_password/forget_password_use_case.dart';
import 'package:customerapp/domain/usecases/login/email_login_use_case.dart';
import 'package:customerapp/domain/usecases/login/mobile_login_use_case.dart';
import 'package:customerapp/domain/usecases/signup/email_signup_use_case.dart';
import 'package:customerapp/domain/usecases/signup/mobile_signup_use_case.dart';
import 'package:customerapp/domain/usecases/signup/signup_use_case.dart';
import 'package:customerapp/presentation/login_screen/controller/auth_controller.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/login/login_use_case.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryIml());

    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => MobileLoginUseCase(Get.find()));
    Get.lazyPut(() => EmailLoginUseCase(Get.find()));

    Get.lazyPut(() => SignupUseCase(Get.find()));
    Get.lazyPut(() => MobileSignupUseCase(Get.find()));
    Get.lazyPut(() => EmailSignupUseCase(Get.find()));

    Get.lazyPut(() => ForgetPasswordUseCase(Get.find()));

    Get.lazyPut(() => AuthController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
