import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HomeRepositoryIml extends HomeRepository {
  @override
  Future<CityResponds?> getCity() async {
    try {
      Response response = await GetIt.I.get<ApiService>().get(NetworkKeys.city,
          options: Options(
            contentType: 'application/json',
          ));

      final CityResponds data = cityRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<CityServiceResponds?> getCityServices(String cityId) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get('${NetworkKeys.cityService}/$cityId',
              options: Options(
                contentType: 'application/json',
              ));

      final CityServiceResponds data =
          cityServiceRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<MidBannerResponds?> getMidBanner() async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get(NetworkKeys.midBanner,
              options: Options(
                contentType: 'application/json',
              ));

      final MidBannerResponds data =
          midBannerRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<ActiveBannerResponds?> getActiveBanner() async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get(NetworkKeys.activeBanner,
              options: Options(
                contentType: 'application/json',
              ));

      final ActiveBannerResponds data =
          bannerRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }
}
