import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:get_storage/get_storage.dart';

class AccountController extends BaseController {
  final sessionStorage = GetStorage();

  var name = "";
  var mobile = "";
  var email = "";
  @override
  void onInit() {
    name = sessionStorage.read(StorageKeys.username) ?? "User";
    mobile = sessionStorage.read(StorageKeys.mobile) ?? "xxxxxxxxx";
    email = sessionStorage.read(StorageKeys.email) ?? "xxx@xxx.xx";
    super.onInit();
  }
}
