import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/home/push_request.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';

class PushTokenUseCase extends ParamUseCase<CommonResponds?, PushRequest> {
  final HomeRepository _repo;
  PushTokenUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(PushRequest params) {
    return _repo.updatePushToken(params);
  }
}
