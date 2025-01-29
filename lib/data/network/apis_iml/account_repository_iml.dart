import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/dio_exception.dart';
import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AccountRepositoryIml extends AccountRepository {
  @override
  Future<ProfileResponse?> updateUser(ProfileRequest request) async {
    try {
      Response response = await GetIt.I.get<ApiService>().put(NetworkKeys.user,
          data: request.toJson(),
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

      final bool data = response.statusCode == 200;

      return data;
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<LoginResponds?> verifyAccount(LoginRequest request) async {
    try {
      var datas = {
        'phone': request.username,
      };

      if (request.from == 'email') {
        datas = {
          'email': request.username,
        };
      }

      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.accountVerification,
              data: datas,
              options: Options(
                contentType: 'application/json',
              ));

      final LoginResponds data = loginRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }

  @override
  Future<LoginResponds?> verifyMobileEmail(LoginRequest request) async {
    try {
      var datas = {
        'phone': request.username,
        'otp': request.password,
      };

      if (request.from == 'email') {
        datas = {
          'email': request.username,
          'otp': request.password,
        };
      }

      Response response = await GetIt.I
          .get<ApiService>()
          .post(NetworkKeys.accountEmailMobileVerification,
              data: datas,
              options: Options(
                contentType: 'application/json',
              ));

      final LoginResponds data = loginRespondsFromJson(response.toString());

      return data;
    } on DioException catch (e) {
      var error = DioExceptionData.fromDioError(e);
      throw error.errorMessage;
    }
  }
}
