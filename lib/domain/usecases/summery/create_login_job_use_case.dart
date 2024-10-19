import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/summery/job__login_responds.dart';
import 'package:customerapp/domain/model/summery/job_request.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class CreateLoginJobUseCase
    extends ParamUseCase<JobLoginResponds?, JobRequest> {
  final ServiceRepository _repo;

  CreateLoginJobUseCase(this._repo);

  @override
  Future<JobLoginResponds?> execute(JobRequest params) {
    return _repo.createLoginJob(params);
  }
}
