import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/repositories/address/address_repository.dart';

class DeleteAddressUseCase
    extends ParamUseCase<CommonResponds?, ConfirmAddressRequest> {
  final AddressRepository _repo;
  DeleteAddressUseCase(this._repo);

  @override
  Future<CommonResponds?> execute(params) {
    return _repo.deleteAddress(params);
  }
}
