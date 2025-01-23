import 'package:customerapp/domain/model/login/login_request.dart';
import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';

import '../../../core/usecases/pram_usecase.dart';

class VerifyEmailMobileUseCase
    extends ParamUseCase<LoginResponds?, LoginRequest> {
  final AccountRepository _repo;
  VerifyEmailMobileUseCase(this._repo);

  @override
  Future<LoginResponds?> execute(LoginRequest params) {
    return _repo.verifyMobileEmail(params);
  }
}
