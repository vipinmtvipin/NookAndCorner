import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/settings/address_request.dart';
import 'package:customerapp/domain/repositories/settings/settings_repository.dart';

class ContactUseCase extends ParamUseCase<CommonResponds?, ContactRequest> {
  final SettingsRepository _repo;

  ContactUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(ContactRequest params) {
    return _repo.contactUs(params);
  }
}
