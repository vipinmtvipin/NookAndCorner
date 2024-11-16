import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class MyJobRepositoryIml extends MyJobRepository {
  @override
  Future<MyJobResponds?> getJob(MyJobRequest request) async {
    try {
      var requestUrl = '';
      if (request.bookingStatus == MyBookingStatus.scheduled.name) {
        requestUrl = '${NetworkKeys.scheduledJob}/${request.userId}';
      } else if (request.bookingStatus == MyBookingStatus.completed.name) {
        requestUrl = '${NetworkKeys.completedJob}/${request.userId}';
      } else if (request.bookingStatus == MyBookingStatus.cancelled.name) {
        requestUrl = '${NetworkKeys.cancelledJob}/${request.userId}';
      } else {
        requestUrl = '${NetworkKeys.pendingJob}/${request.userId}';
      }

      Response response = await GetIt.I.get<ApiService>().get(requestUrl,
          options: Options(
            contentType: 'application/json',
          ));

      final MyJobResponds data = myJobRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CommonResponds?> cancelJob(String jobId) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.cancelJob,
              options: Options(
                contentType: 'application/json',
              ),
              data: {"id": jobId});

      final CommonResponds data = commonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CommonResponds?> ratingJob(JobCommentRequest request) async {
    try {
      Response response = await GetIt.I.get<ApiService>().post(
          NetworkKeys.rating,
          options: Options(
            contentType: 'application/json',
          ),
          data: {
            "jobId": request.jobId,
            "rating": request.comment,
            "userId": request.userId
          });

      final CommonResponds data = commonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CommonResponds?> reScheduleJob(ReScheduleJobRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().put(NetworkKeys.reSchedule,
              options: Options(
                contentType: 'application/json',
              ),
              data: request.toJson());

      final CommonResponds data = commonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CommonResponds?> reviewJob(JobCommentRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().put(NetworkKeys.comment,
              options: Options(
                contentType: 'application/json',
              ),
              data: request.toJson());

      final CommonResponds data = commonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CommonResponds?> confirmAddress(ConfirmAddressRequest request) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .put('${NetworkKeys.confirmAddress}/${request.addressId}',
              data: request.toJson(),
              options: Options(
                contentType: 'application/json',
              ));

      final CommonResponds data = commonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }
}
