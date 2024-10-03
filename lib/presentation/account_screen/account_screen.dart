import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customerapp/core/theme/color_constant.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_text_style.dart';
import 'controller/account_controller.dart';

class AccountScreen extends GetWidget<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Text('Account Screen'),
          ),
        ));
  }
}

/// Navigates to the previous screen.
onTapArrowLeft() {
  Get.back();
}

onTapLoginNavigation() {
  Get.toNamed(
    AppRoutes.loginScreen,
  );
}

class ProfileItemsWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function() onTap;

  const ProfileItemsWidget({
    super.key,
    required this.iconData,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        size: 20,
        color: AppColors.darkGray,
      ),
      title: Text(label,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppTextStyle.txtBold14.copyWith(color: AppColors.black)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: AppColors.darkGray,
      ),
    );
  }
}
