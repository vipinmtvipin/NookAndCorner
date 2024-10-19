import 'package:customerapp/data/network/apis_iml/service_repository_iml.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';
import 'package:customerapp/domain/usecases/service/service_by_tag_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_details_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_slots_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_tags_use_case.dart';
import 'package:customerapp/domain/usecases/summery/addons_use_case.dart';
import 'package:customerapp/domain/usecases/summery/apply_coupon_use_case.dart';
import 'package:customerapp/domain/usecases/summery/create_job_use_case.dart';
import 'package:customerapp/domain/usecases/summery/create_login_job_use_case.dart';
import 'package:customerapp/domain/usecases/summery/meta_use_case.dart';
import 'package:customerapp/domain/usecases/summery/summery_use_case.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:get/get.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ServiceRepository>(ServiceRepositoryIml());
    Get.put<ServiceDetailsByTagUseCase>(ServiceDetailsByTagUseCase(Get.find()));
    Get.put<ServiceDetailsUseCase>(ServiceDetailsUseCase(Get.find()));
    Get.put<ServiceTagsUseCase>(ServiceTagsUseCase(Get.find()));
    Get.put<ServiceSlotsUseCase>(ServiceSlotsUseCase(Get.find()));
    Get.put<CreateLoginJobUseCase>(CreateLoginJobUseCase(Get.find()));
    Get.put<CreateJobUseCase>(CreateJobUseCase(Get.find()));
    Get.put<AddonsUseCase>(AddonsUseCase(Get.find()));
    Get.put<MetaUseCase>(MetaUseCase(Get.find()));
    Get.put<ApplyCouponUseCase>(ApplyCouponUseCase(Get.find()));
    Get.put<SummeryUseCase>(SummeryUseCase(Get.find()));

    Get.put<ServiceController>(ServiceController(
      Get.find(),
      Get.find(),
      Get.find(),
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
