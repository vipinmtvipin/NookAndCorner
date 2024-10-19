import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/summery/job_request.dart';
import 'package:customerapp/domain/model/summery/job_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class CreateJobUseCase extends ParamUseCase<JobResponds?, JobRequest> {
  final ServiceRepository _repo;

  CreateJobUseCase(this._repo);

  @override
  Future<JobResponds?> execute(JobRequest params) {
    return _repo.createJob(params);
  }
}
