import 'package:customerapp/domain/model/address/address_request.dart';
import 'package:customerapp/domain/model/address/address_responds.dart';

abstract class AddressRepository {
  Future<AddressResponds?> getAddress(String userId);
  Future<AddressResponds?> saveAddress(AddressRequest request);
}
