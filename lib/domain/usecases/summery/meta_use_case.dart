import 'package:customerapp/core/usecases/no_param_usecase.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class MetaUseCase extends NoParamUseCase<MetaResponds?> {
  final ServiceRepository _repo;
  MetaUseCase(this._repo);

  @override
  Future<MetaResponds?> execute() {
    return _repo.getMetaData();
  }
}
