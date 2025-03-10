import 'package:customerapp/data/network/apis_iml/address_repository_iml.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';
import 'package:customerapp/domain/usecases/address/confirm_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/delete_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/get_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/primary_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/save_addrress_use_case.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:get/get.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddressRepository>(AddressRepositoryIml());
    Get.put<GetAddressUseCase>(GetAddressUseCase(Get.find()));
    Get.put<SaveAddressUseCase>(SaveAddressUseCase(Get.find()));
    Get.put<ConfirmAddressUseCase>(ConfirmAddressUseCase(Get.find()));
    Get.put<PrimaryAddressUseCase>(PrimaryAddressUseCase(Get.find()));
    Get.put<DeleteAddressUseCase>(DeleteAddressUseCase(Get.find()));
    Get.put<AddressController>(AddressController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
