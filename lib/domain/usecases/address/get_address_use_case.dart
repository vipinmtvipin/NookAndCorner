import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';

class GetAddressUseCase
    extends ParamUseCase<AddressResponds?, GetAddressRequest> {
  final AddressRepository _repo;
  GetAddressUseCase(this._repo);

  @override
  Future<AddressResponds?> execute(GetAddressRequest params) {
    return _repo.getAddress(params);
  }
}
