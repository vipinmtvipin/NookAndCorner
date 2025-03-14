import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/account/profile_request.dart';
import 'package:customerapp/domain/model/account/profile_response.dart';
import 'package:customerapp/domain/repositories/account/account_repository.dart';

class UpdateAccountUseCase
    extends ParamUseCase<ProfileResponse?, ProfileRequest> {
  final AccountRepository _repo;
  UpdateAccountUseCase(this._repo);

  @override
  Future<ProfileResponse?> execute(ProfileRequest params) {
    return _repo.updateUser(params);
  }
}
