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
  Future<List<CityResponds>?> getCity() async {
    try {
      Response response = await GetIt.I.get<ApiService>().get(NetworkKeys.city,
          options: Options(
            contentType: 'application/json',
          ));

      final List<CityResponds> data = CityResponds.fromJsonList(response.data);

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<List<CityServiceResponds>?> getCityServices(String cityId) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get('${NetworkKeys.cityService}/$cityId',
              options: Options(
                contentType: 'application/json',
              ));

      final List<CityServiceResponds> data =
          CityServiceResponds.fromJsonList(response.data);

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<List<MidBannerResponds>?> getMidBanner() async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get(NetworkKeys.midBanner,
              options: Options(
                contentType: 'application/json',
              ));

      final List<MidBannerResponds> data =
          MidBannerResponds.fromJsonList(response.data);

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<List<ActiveBannerResponds>?> getActiveBanner() async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get(NetworkKeys.activeBanner,
              options: Options(
                contentType: 'application/json',
              ));

      final List<ActiveBannerResponds> data =
          ActiveBannerResponds.fromJsonList(response.data);

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }
}
