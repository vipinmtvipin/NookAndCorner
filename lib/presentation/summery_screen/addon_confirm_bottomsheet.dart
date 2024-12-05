import 'package:customerapp/core/theme/app_text_style.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/presentation/common_widgets/network_image_view.dart';
import 'package:customerapp/presentation/common_widgets/nookcorner_button.dart';
import 'package:customerapp/presentation/common_widgets/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddonConfirmBottomSheet extends StatelessWidget {
  final List<AddOnData> addOns;
  final Function() onConfirm;
  const AddonConfirmBottomSheet({
    super.key,
    required this.addOns,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Confirm Add-Ons',
            textAlign: TextAlign.center,
            style: AppTextStyle.txtBold18,
          ),
          const SizedBox(height: 20),
          Text('You have added following add-ons:', style: AppTextStyle.txt14),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: addOns.length,
            itemBuilder: (context, index) {
              final item = addOns[index];
              return AddOnCard(
                addon: item,
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Once confirmed, changes are not allowed. This includes removing, reducing quantities, or canceling these add-ons.',
            style: AppTextStyle.txt14,
          ),
          const SizedBox(height: 20),
          Text(
            textAlign: TextAlign.start,
            'Do you wish to proceed with this booking?',
            style: AppTextStyle.txt14,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              NookCornerButton(
                width: 80,
                type: NookCornerButtonType.outlined,
                outlinedColor: AppColors.primaryColor,
                textStyle: AppTextStyle.txtBoldWhite14,
                text: 'Cancel',
                onPressed: () {
                  Get.back();
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: NookCornerButton(
                  outlinedColor: AppColors.primaryColor,
                  textStyle: AppTextStyle.txtBoldWhite14,
                  text: 'Confirm and proceed',
                  backGroundColor: AppColors.primaryColor,
                  onPressed: () {
                    Get.back();
                    onConfirm();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class AddOnCard extends StatelessWidget {
  final AddOnData addon;

  const AddOnCard({
    super.key,
    required this.addon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white,
      child: SizedBox(
        width: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetworkImageView(
                  borderRadius: 10,
                  url: addon.logo ?? '',
                  width: 60,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              ResponsiveText(
                text: "${addon.titile ?? ''} (${addon.quantity ?? 0})",
                style: AppTextStyle.txt12,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
