import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
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
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.timeSlot,
              data: {
                "categoryId": request.categoryId,
                "jobDate": request.jobDate,
                "serviceId": request.serviceId
              },
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
}
