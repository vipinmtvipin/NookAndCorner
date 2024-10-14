import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';

class SaveAddressUseCase
    extends ParamUseCase<AddressResponds?, AddressRequest> {
  final AddressRepository _repo;
  SaveAddressUseCase(this._repo);

  @override
  Future<AddressResponds?> execute(AddressRequest param) {
    return _repo.saveAddress(param);
  }
}
