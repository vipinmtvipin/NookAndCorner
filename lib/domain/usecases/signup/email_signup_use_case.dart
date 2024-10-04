import 'package:customerapp/domain/model/login/login_responds.dart';

import '../../../core/usecases/pram_usecase.dart';
import '../../repositories/auth/auth_repository.dart';

class EmailSignupUseCase extends ParamUseCase<LoginResponds?, String> {
  final AuthRepository _repo;
  EmailSignupUseCase(this._repo);

  @override
  Future<LoginResponds?> execute(String params) {
    return _repo.signupEmail(params);
  }
}
