import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';

import '../../../core/usecases/pram_usecase.dart';
import '../../repositories/auth/auth_repository.dart';

class LoginUseCase extends ParamUseCase<LoginResponds?, LoginRequest> {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  @override
  Future<LoginResponds?> execute(LoginRequest params) {
    return _repo.login(params);
  }
}
