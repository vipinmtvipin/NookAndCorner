import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/model/summery/job__login_responds.dart';
import 'package:customerapp/domain/model/summery/job_request.dart';
import 'package:customerapp/domain/model/summery/job_responds.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';

abstract class ServiceRepository {
  Future<ServiceDetailsResponds?> getServiceDetails(String categoryId);
  Future<TagResponds?> getServiceTags(String categoryId);
  Future<ServiceDetailsResponds?> getServiceByTag(
      TimeSlotRequest timeSlotRequest);
  Future<TimeSlotResponds?> getTimeSlotes(TimeSlotRequest request);

  Future<MetaResponds?> getMetaData();
  Future<AddOnListResponds?> getAddOns(AddonRequest request);
  Future<CuponResponds?> applyCoupon(CouponRequest request);
  Future<JobResponds?> createJob(JobRequest request);
  Future<JobLoginResponds?> createLoginJob(JobRequest request);
}
