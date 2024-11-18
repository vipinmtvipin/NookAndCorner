import 'package:customerapp/data/network/apis_iml/account_repository_iml.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';
import 'package:customerapp/domain/usecases/account/delete_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/get_account_use_case.dart';
import 'package:customerapp/domain/usecases/account/update_account_use_case.dart';
import 'package:customerapp/presentation/account_screen/controller/account_controller.dart';
import 'package:get/get.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AccountRepository>(AccountRepositoryIml());
    Get.put<GetAccountUseCase>(GetAccountUseCase(Get.find()));
    Get.put<UpdateAccountUseCase>(UpdateAccountUseCase(Get.find()));
    Get.put<DeleteAccountUseCase>(DeleteAccountUseCase(Get.find()));

    Get.put<AccountController>(AccountController(
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
