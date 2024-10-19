import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AccountController extends BaseController {
  final sessionStorage = GetStorage();

  var name = "";
  var mobile = "";
  var email = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
  }

  @override
  void onInit() {
    name = sessionStorage.read(StorageKeys.username) ?? "";
    mobile = sessionStorage.read(StorageKeys.mobile) ?? "";
    email = sessionStorage.read(StorageKeys.email) ?? "";

    emailController.text = email;
    phoneController.text = mobile;
    nameController.text = name;
    super.onInit();
  }
}
