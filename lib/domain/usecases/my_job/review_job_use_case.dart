import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';

class ReviewJobUseCase
    extends ParamUseCase<CommonResponds?, JobCommentRequest> {
  final MyJobRepository _repo;
  ReviewJobUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(params) {
    return _repo.reviewJob(params);
  }
}
