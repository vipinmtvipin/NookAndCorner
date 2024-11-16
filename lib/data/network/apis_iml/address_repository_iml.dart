import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AddressRepositoryIml extends AddressRepository {
  @override
  Future<CommonResponds?> saveAddress(AddressRequest request) async {
    try {
      Response response;
      if (request.addressId.isNotNullOrEmpty) {
        response = await GetIt.I.get<ApiService>().put(NetworkKeys.saveAddress,
            data: request.toJson(),
            options: Options(
              contentType: 'application/json',
            ));
      } else {
        response = await GetIt.I.get<ApiService>().post(NetworkKeys.saveAddress,
            data: request.toJson(),
            options: Options(
              contentType: 'application/json',
            ));
      }

      final CommonResponds data = commonRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<AddressResponds?> getAddress(GetAddressRequest request) async {
    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get('${NetworkKeys.getAddress}/${request.userId}',
              queryParameters: {"cityId": request.cityId},
              options: Options(
                contentType: 'application/json',
              ));

      final AddressResponds data =
          addressListRespondsFromJson(response.toString());

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
