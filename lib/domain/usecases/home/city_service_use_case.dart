import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';

class CityServiceUseCase extends ParamUseCase<CityServiceResponds?, String> {
  final HomeRepository _repo;
  CityServiceUseCase(this._repo);

  @override
  Future<CityServiceResponds?> execute(cityId) {
    return _repo.getCityServices(cityId);
  }
}
