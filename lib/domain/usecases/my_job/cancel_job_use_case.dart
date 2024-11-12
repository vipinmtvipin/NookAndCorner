import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';

class CancelJobUseCase extends ParamUseCase<CommonResponds?, String> {
  final MyJobRepository _repo;
  CancelJobUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(params) {
    return _repo.cancelJob(params);
  }
}
