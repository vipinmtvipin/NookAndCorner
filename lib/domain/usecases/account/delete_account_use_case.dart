import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';

class DeleteAccountUseCase extends ParamUseCase<bool?, String> {
  final AccountRepository _repo;
  DeleteAccountUseCase(this._repo);

  @override
  Future<bool?> execute(String params) {
    return _repo.deleteAccount(params);
  }
}
