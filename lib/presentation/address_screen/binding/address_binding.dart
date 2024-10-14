import 'package:customerapp/data/network/apis_iml/address_repository_iml.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';
import 'package:customerapp/domain/usecases/address/get_address_use_case.dart';
import 'package:customerapp/domain/usecases/address/save_addrress_use_case.dart';
import 'package:customerapp/presentation/address_screen/controller/address_controller.dart';
import 'package:get/get.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddressRepository>(AddressRepositoryIml());
    Get.put<GetAddressUseCase>(GetAddressUseCase(Get.find()));
    Get.put<SaveAddressUseCase>(SaveAddressUseCase(Get.find()));

    Get.lazyPut(() => AddressController(
          Get.find(),
          Get.find(),
        ));
  }
}
