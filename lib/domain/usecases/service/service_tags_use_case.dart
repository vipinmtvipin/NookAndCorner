import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class ServiceTagsUseCase extends ParamUseCase<TagResponds?, String> {
  final ServiceRepository _repo;
  ServiceTagsUseCase(this._repo);

  @override
  Future<TagResponds?> execute(String id) {
    return _repo.getServiceTags(id);
  }
}
