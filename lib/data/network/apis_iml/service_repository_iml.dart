import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/model/summery/job_login_responds.dart';
import 'package:customerapp/domain/model/summery/job_request.dart';
import 'package:customerapp/domain/model/summery/job_responds.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ServiceRepositoryIml extends ServiceRepository {
  @override
  Future<ServiceDetailsResponds?> getServiceByTag(
      TimeSlotRequest request) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get('${NetworkKeys.serviceTagItems}/${request.tagId}',
              queryParameters: {
                "catId": request.categoryId,
              },
              options: Options(
                contentType: 'application/json',
              ));

      final ServiceDetailsResponds data =
          serviceRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<ServiceDetailsResponds?> getServiceDetails(String categoryId) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get('${NetworkKeys.serviceDetails}/$categoryId',
              options: Options(
                contentType: 'application/json',
              ));

      final ServiceDetailsResponds data =
          serviceRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<TagResponds?> getServiceTags(String categoryId) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get('${NetworkKeys.serviceTag}/$categoryId',
              options: Options(
                contentType: 'application/json',
              ));

      final TagResponds data = tagRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<TimeSlotResponds?> getTimeSlotes(TimeSlotRequest request) async {
    try {
      var requestData = {};
      if (request.userId.isNotNullOrEmpty && request.userId != "null") {
        requestData = {
          "categoryId": request.categoryId,
          "jobDate": request.jobDate,
          "serviceId": request.serviceId,
          "userId": request.userId,
        };
      } else {
        requestData = {
          "categoryId": request.categoryId,
          "jobDate": request.jobDate,
          "serviceId": request.serviceId,
        };
      }
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.timeSlot,
              data: requestData,
              options: Options(
                contentType: 'application/json',
              ));

      final TimeSlotResponds data =
          timeSlotRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CuponResponds?> applyCoupon(CouponRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.applyCoupon,
              data: {
                "slot": request.slot,
                "promotionName": request.promotionName,
                "serviceId": request.serviceId
              },
              options: Options(
                contentType: 'application/json',
              ));

      final CuponResponds data = cuponRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<AddOnListResponds?> getAddOns(AddonRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get(NetworkKeys.addOns,
              queryParameters: {
                "subServiceId": request.subServiceId,
                "status": request.status,
                "offset": request.offset,
                "limit": request.limit
              },
              options: Options(
                contentType: 'application/json',
              ));

      final AddOnListResponds data = addonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<MetaResponds?> getMetaData() async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get(NetworkKeys.metaData,
              options: Options(
                contentType: 'application/json',
              ));

      final MetaResponds data = metaRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<JobResponds?> createJob(JobRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.createJob,
              data: request.toJson(),
              options: Options(
                contentType: 'application/json',
              ));

      final JobResponds data = jobRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<JobLoginResponds?> createLoginJob(JobRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.createJobLogin,
              data: request.toJson(),
              options: Options(
                contentType: 'application/json',
              ));

      final JobLoginResponds data =
          jobLoginRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }
}
