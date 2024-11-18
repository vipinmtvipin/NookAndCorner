import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/model/common_responds.dart';

abstract class AccountRepository {
  Future<ProfileResponse?> getUser(String request);
  Future<CommonResponds?> updateUser(ProfileRequest request);
  Future<bool?> deleteAccount(String request);
}
