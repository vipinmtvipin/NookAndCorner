import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class AddonsUseCase extends ParamUseCase<AddOnListResponds?, AddonRequest> {
  final ServiceRepository _repo;

  AddonsUseCase(this._repo);

  @override
  Future<AddOnListResponds?> execute(AddonRequest params) {
    return _repo.getAddOns(params);
  }
}
