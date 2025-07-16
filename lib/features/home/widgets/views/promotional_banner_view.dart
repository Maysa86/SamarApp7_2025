import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../banner/controllers/banner_controller.dart';
import '../../../../util/dimensions.dart';
import '../../../../common/widgets/custom_image.dart';

class PromotionalBannerView extends StatelessWidget {
  const PromotionalBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return bannerController.promotionalBanner != null ? bannerController.promotionalBanner!.bottomSectionBannerFullUrl != null ? Container(
        height: 90, width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          child: CustomImage(
            image: '${bannerController.promotionalBanner!.bottomSectionBannerFullUrl}',
            fit: BoxFit.cover, height: 80, width: double.infinity,
          ),
        ),
      ) : const SizedBox() : const PromotionalBannerShimmerView();
    });
  }
}

class PromotionalBannerShimmerView extends StatelessWidget {
  const PromotionalBannerShimmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
      ),
    );

  }
}