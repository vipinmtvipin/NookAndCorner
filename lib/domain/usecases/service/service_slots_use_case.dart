import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class ServiceSlotsUseCase
    extends ParamUseCase<TimeSlotResponds?, TimeSlotRequest> {
  final ServiceRepository _repo;

  ServiceSlotsUseCase(this._repo);

  @override
  Future<TimeSlotResponds?> execute(TimeSlotRequest params) {
    return _repo.getTimeSlotes(params);
  }
}
