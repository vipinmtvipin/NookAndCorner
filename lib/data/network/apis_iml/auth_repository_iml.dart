import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:customerapp/domain/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants/constants.dart';
import '../../../core/network/dio_exception.dart';

class AuthRepositoryIml extends AuthRepository {
  @override
  Future<LoginResponds?> loginMobile(String username) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.loginMobile,
              data: {
                'username': username,
              },
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
  Future<LoginResponds?> loginEmail(String username) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.loginEmail,
              data: {
                'username': username,
              },
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
  Future<LoginResponds?> login(LoginRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.login,
              data: {
                'username': request.username,
                'password': request.password,
              },
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
  Future<LoginResponds?> signupMobile(String username) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.signupMobile,
              data: {
                'phone': username,
              },
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
  Future<LoginResponds?> signupEmail(String username) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.signupEmail,
              data: {
                'email': username,
              },
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
  Future<LoginResponds?> signup(LoginRequest request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.signup,
              data: {
                'phone': request.username,
                'otp': request.password,
              },
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
  Future<LoginResponds?> forgetPassword(String request) async {
    try {
      Response response =
          await GetIt.I.get<ApiService>().post(NetworkKeys.forgetPassword,
              data: {
                'email': request,
              },
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
