import 'package:cached_network_image/cached_network_image.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/theme/color_constant.dart';
import 'package:customerapp/generated/assets.gen.dart';
import 'package:customerapp/presentation/common_widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final VoidCallback? onTap;
  final double? borderRadius;

  const NetworkImageView({
    super.key,
    this.url,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIcon = CustomImageView(
      imagePath: Assets.images.nookCornerRound.path,
      fit: BoxFit.cover,
    );

    return InkWell(
        onTap: onTap,
        child: url.isNullOrEmpty
            ? defaultIcon
            : ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? 0),
                child: CachedNetworkImage(
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.contain,
                  imageUrl: url!,
                  placeholder: (context, url) {
                    return const Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => defaultIcon,
                ),
              ));
  }
}
