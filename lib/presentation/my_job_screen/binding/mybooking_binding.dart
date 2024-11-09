import 'package:customerapp/data/network/apis_iml/myjob_repository_iml.dart';
import 'package:customerapp/data/network/apis_iml/service_repository_iml.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';
import 'package:customerapp/domain/usecases/my_job/my_job_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_slots_use_case.dart';
import 'package:customerapp/domain/usecases/summery/summery_use_case.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:get/get.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MyJobRepository>(MyJobRepositoryIml());
    Get.put<MyJobUseCase>(MyJobUseCase(Get.find()));
    Get.put<ServiceRepository>(ServiceRepositoryIml());
    Get.put<SummeryUseCase>(SummeryUseCase(Get.find()));
    Get.put<ServiceSlotsUseCase>(ServiceSlotsUseCase(Get.find()));

    Get.put<MyBookingController>(MyBookingController(
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
