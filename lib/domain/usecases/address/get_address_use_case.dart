import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';

class GetAddressUseCase extends ParamUseCase<AddressResponds?, String> {
  final AddressRepository _repo;
  GetAddressUseCase(this._repo);

  @override
  Future<AddressResponds?> execute(String id) {
    return _repo.getAddress(id);
  }
}
