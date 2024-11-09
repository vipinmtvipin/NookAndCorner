import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';

class MyJobUseCase extends ParamUseCase<MyJobResponds?, MyJobRequest> {
  final MyJobRepository _repo;
  MyJobUseCase(this._repo);

  @override
  Future<MyJobResponds?> execute(params) {
    return _repo.getJob(params);
  }
}
