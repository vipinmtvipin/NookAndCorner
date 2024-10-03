import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';

import '../../../core/usecases/pram_usecase.dart';
import '../../repositories/auth/auth_repository.dart';

class SignupUseCase extends ParamUseCase<LoginResponds?, LoginRequest> {
  final AuthRepository _repo;
  SignupUseCase(this._repo);

  @override
  Future<LoginResponds?> execute(LoginRequest params) {
    return _repo.signup(params);
  }
}
