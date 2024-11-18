import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';

class GetAccountUseCase extends ParamUseCase<ProfileResponse?, String> {
  final AccountRepository _repo;
  GetAccountUseCase(this._repo);

  @override
  Future<ProfileResponse?> execute(String params) {
    return _repo.getUser(params);
  }
}
