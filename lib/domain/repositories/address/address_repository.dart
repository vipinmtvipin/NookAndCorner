import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';
import 'package:customerapp/domain/model/common_responds.dart';

abstract class AddressRepository {
  Future<AddressResponds?> getAddress(GetAddressRequest request);
  Future<CommonResponds?> saveAddress(AddressRequest request);
  Future<CommonResponds?> confirmAddress(ConfirmAddressRequest request);
  Future<CommonResponds?> deleteAddress(ConfirmAddressRequest request);
  Future<CommonResponds?> primaryAddress(ConfirmAddressRequest request);
}
