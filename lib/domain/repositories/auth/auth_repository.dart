import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';

abstract class AuthRepository {
  Future<LoginResponds?> loginMobile(String username);
  Future<LoginResponds?> loginEmail(String username);
  Future<LoginResponds?> login(LoginRequest request);
  Future<LoginResponds?> signupMobile(String username);
  Future<LoginResponds?> signupEmail(String username);
  Future<LoginResponds?> signup(LoginRequest request);
  Future<LoginResponds?> jobCreateVerifyOtp(LoginRequest request);
  Future<LoginResponds?> forgetPassword(String request);
}
