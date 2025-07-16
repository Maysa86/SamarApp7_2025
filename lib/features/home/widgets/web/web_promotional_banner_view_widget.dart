import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../banner/controllers/banner_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../common/widgets/custom_image.dart';

class WebPromotionalBannerView extends StatelessWidget {
  const WebPromotionalBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        child: bannerController.promotionalBanner != null ? Container(
          height: 235, width: context.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            child: CustomImage(
              image: '${bannerController.promotionalBanner!.bottomSectionBannerFullUrl}',
              fit: BoxFit.cover, height: 235, width: double.infinity,
            ),
          ),
        ) : const WebPromotionalBannerShimmerView(),
      );
    });
  }
}

class WebPromotionalBannerShimmerView extends StatelessWidget {
  const WebPromotionalBannerShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 235,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
      ),
    );

  }
}
