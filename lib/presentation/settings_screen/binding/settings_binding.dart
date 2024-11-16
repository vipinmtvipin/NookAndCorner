import 'package:customerapp/data/network/apis_iml/settings_repository_iml.dart';
import 'package:customerapp/domain/repositories/settings/settings_repository.dart';
import 'package:customerapp/domain/usecases/settings/contact_use_case.dart';
import 'package:customerapp/domain/usecases/settings/reviews_use_case.dart';
import 'package:customerapp/presentation/settings_screen/controller/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsRepository>(SettingsRepositoryIml());
    Get.put<ContactUseCase>(ContactUseCase(Get.find()));
    Get.put<ReviewsUseCase>(ReviewsUseCase(Get.find()));

    Get.put<SettingsController>(SettingsController(
      Get.find(),
      Get.find(),
    ));
  }
}
