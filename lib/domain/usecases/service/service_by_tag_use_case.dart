import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class ServiceDetailsByTagUseCase
    extends ParamUseCase<ServiceDetailsResponds?, TimeSlotRequest> {
  final ServiceRepository _repo;
  ServiceDetailsByTagUseCase(this._repo);

  @override
  Future<ServiceDetailsResponds?> execute(TimeSlotRequest param) {
    return _repo.getServiceByTag(param);
  }
}
