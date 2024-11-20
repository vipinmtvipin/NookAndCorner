import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/settings/address_request.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/repositories/settings/settings_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class SettingsRepositoryIml extends SettingsRepository {
  @override
  Future<CommonResponds?> contactUs(ContactRequest request) async {
    try {
      Response response;

      response = await GetIt.I.get<ApiService>().post(NetworkKeys.contact,
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

  @override
  Future<ReviewListResponds?> reviewList(ReviewRequest request) async {
    try {
      Response response;

      response = await GetIt.I.get<ApiService>().get(NetworkKeys.reviews,
          queryParameters: request.toJson(),
          options: Options(
            contentType: 'application/json',
          ));

      final ReviewListResponds data =
          reviewsListRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }
}
