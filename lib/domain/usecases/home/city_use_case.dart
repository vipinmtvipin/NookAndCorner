import 'package:customerapp/core/usecases/no_param_usecase.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';

class CityUseCase extends NoParamUseCase<List<CityResponds>?> {
  final HomeRepository _repo;
  CityUseCase(this._repo);

  @override
  Future<List<CityResponds>?> execute() {
    return _repo.getCity();
  }
}
