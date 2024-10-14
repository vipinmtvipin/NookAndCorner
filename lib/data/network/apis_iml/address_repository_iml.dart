import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';

class AddressRepositoryIml extends AddressRepository {
  @override
  Future<AddressResponds?> saveAddress(AddressRequest request) async {
/*    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get(NetworkKeys.saveAddress,
              queryParameters: {
                "catId": ''
              },
              options: Options(
                contentType: 'application/json',
              ));

      final AddressResponds data =
          serviceRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }*/
  }

  @override
  Future<AddressResponds?> getAddress(String userId) async {
/*    try {
      Response response = await GetIt.I
          .get<ApiService>()
          .get(NetworkKeys.getAddress,
              options: Options(
                contentType: 'application/json',
              ));

      final AddressResponds data =
          serviceRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }*/
  }
}
