import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class ServiceDetailsUseCase
    extends ParamUseCase<ServiceDetailsResponds?, String> {
  final ServiceRepository _repo;
  ServiceDetailsUseCase(this._repo);

  @override
  Future<ServiceDetailsResponds?> execute(String catId) {
    return _repo.getServiceDetails(catId);
  }
}
