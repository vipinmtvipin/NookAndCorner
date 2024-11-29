import 'package:customerapp/data/network/apis_iml/myjob_repository_iml.dart';
import 'package:customerapp/data/network/apis_iml/service_repository_iml.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';
import 'package:customerapp/domain/usecases/my_job/add_coupon_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/cancel_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/file_upload_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/my_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/rating_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/reschedule_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/review_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/update_addon_use_case.dart';
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
    Get.put<CancelJobUseCase>(CancelJobUseCase(Get.find()));
    Get.put<RatingJobUseCase>(RatingJobUseCase(Get.find()));
    Get.put<RescheduleJobUseCase>(RescheduleJobUseCase(Get.find()));
    Get.put<ReviewJobUseCase>(ReviewJobUseCase(Get.find()));
    Get.put<FileUploadUseCase>(FileUploadUseCase(Get.find()));
    Get.put<UpdateAddonUseCase>(UpdateAddonUseCase(Get.find()));
    Get.put<AddCouponUseCase>(AddCouponUseCase(Get.find()));

    Get.put<MyBookingController>(MyBookingController(
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
