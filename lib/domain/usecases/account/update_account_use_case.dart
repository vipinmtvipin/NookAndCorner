import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';

class UpdateAccountUseCase
    extends ParamUseCase<CommonResponds?, ProfileRequest> {
  final AccountRepository _repo;
  UpdateAccountUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(ProfileRequest params) {
    return _repo.updateUser(params);
  }
}
