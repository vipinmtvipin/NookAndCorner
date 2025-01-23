import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';

abstract class AccountRepository {
  Future<ProfileResponse?> getUser(String request);
  Future<CommonResponds?> updateUser(ProfileRequest request);
  Future<bool?> deleteAccount(String request);
  Future<LoginResponds?> verifyAccount(LoginRequest request);
  Future<LoginResponds?> verifyMobileEmail(LoginRequest request);
}
