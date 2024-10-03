import 'package:customerapp/data/network/apis_iml/auth_repository_iml.dart';
import 'package:customerapp/domain/repositories/auth/auth_repository.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // HERE WE CAN ADD ALL THE DEPENDENCIES
    // WHICH WE WANT TO INITIALIZE AT THE START OF THE APP

    Get.lazyPut<AuthRepository>(() => AuthRepositoryIml());
  }
}
