import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';

import '../../../core/usecases/pram_usecase.dart';

class VerifyAccountUseCase extends ParamUseCase<LoginResponds?, LoginRequest> {
  final AccountRepository _repo;
  VerifyAccountUseCase(this._repo);

  @override
  Future<LoginResponds?> execute(LoginRequest params) {
    return _repo.verifyAccount(params);
  }
}
