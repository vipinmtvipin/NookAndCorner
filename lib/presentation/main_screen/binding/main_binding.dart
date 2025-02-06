import 'package:customerapp/data/network/apis_iml/home_repository_iml.dart';
import 'package:customerapp/data/network/apis_iml/myjob_repository_iml.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';
import 'package:customerapp/domain/usecases/home/city_service_use_case.dart';
import 'package:customerapp/domain/usecases/home/home_use_case.dart';
import 'package:customerapp/domain/usecases/home/push_token_use_case.dart';
import 'package:customerapp/domain/usecases/home/reviews_list_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/my_job_use_case.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:get/get.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeRepository>(HomeRepositoryIml());
    Get.put<HomeUseCase>(HomeUseCase(Get.find()));
    Get.put<CityServiceUseCase>(CityServiceUseCase(Get.find()));
    Get.put<PushTokenUseCase>(PushTokenUseCase(Get.find()));
    Get.put<ReviewsListUseCase>(ReviewsListUseCase(Get.find()));
    Get.put<MyJobRepository>(MyJobRepositoryIml());
    Get.put<MyJobUseCase>(MyJobUseCase(Get.find()));

    Get.put<MainScreenController>(MainScreenController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
