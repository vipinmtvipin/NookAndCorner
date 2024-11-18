import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AccountRepositoryIml extends AccountRepository {
  @override
  Future<CommonResponds?> updateUser(ProfileRequest request) async {
    try {
      Response response = await GetIt.I.get<ApiService>().put(NetworkKeys.user,
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
  Future<ProfileResponse?> getUser(String request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().get('${NetworkKeys.user}/$request',
              options: Options(
                contentType: 'application/json',
              ));

      final ProfileResponse data =
          profileListRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<bool?> deleteAccount(String request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().delete('${NetworkKeys.user}/$request',
              options: Options(
                contentType: 'application/json',
              ));

      print(" codeeeee------ ${response.runtimeType}");
      final bool data = response.statusCode == 200;

      return data;
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return true;
    }
  }
}
