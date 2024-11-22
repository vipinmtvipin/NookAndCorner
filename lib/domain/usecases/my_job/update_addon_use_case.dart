import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/my_jobs/update_addon_request.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';

class UpdateAddonUseCase
    extends ParamUseCase<CommonResponds?, UpdateAddonRequest> {
  final MyJobRepository _repo;
  UpdateAddonUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(params) {
    return _repo.updateAddOns(params);
  }
}
