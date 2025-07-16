import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../item/controllers/campaign_controller.dart';
import '../../../splash/controllers/splash_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../common/widgets/custom_image.dart';

class MiddleSectionBannerView extends StatefulWidget {
  const MiddleSectionBannerView({super.key});

  @override
  State<MiddleSectionBannerView> createState() =>
      _MiddleSectionBannerViewState();
}

class _MiddleSectionBannerViewState extends State<MiddleSectionBannerView> {
  final carousel.CarouselController carouselController =
      carousel.CarouselController();

  @override
  Widget build(BuildContext context) {
    bool isPharmacy = Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy;

    return GetBuilder<CampaignController>(builder: (campaignController) {
      return campaignController.basicCampaignList != null
          ? campaignController.basicCampaignList!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                      horizontal: Dimensions.paddingSizeSmall),
                  child: Column(children: [
                    carousel.CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: campaignController.basicCampaignList!.length,
                      options: carousel.CarouselOptions(
                        height: isPharmacy ? 187 : 135,
                        //autoPlay: true,
                        enlargeCenterPage: true,
                        disableCenter: true,
                        viewportFraction: 0.95,
                        onPageChanged: (index, reason) {
                          campaignController.setCurrentIndex(index, true);
                        },
                      ),
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        return InkWell(
                          onTap: () =>
                              Get.toNamed(RouteHelper.getBasicCampaignRoute(
                            campaignController.basicCampaignList![itemIndex],
                          )),
                          child: Container(
                            height: isPharmacy ? 187 : 135,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusLarge),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusLarge),
                              child: CustomImage(
                                image:
                                    '${campaignController.basicCampaignList![itemIndex].imageFullUrl}',
                                fit: BoxFit.cover,
                                height: 80,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          campaignController.basicCampaignList!.map((bnr) {
                        int index =
                            campaignController.basicCampaignList!.indexOf(bnr);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: index == campaignController.currentIndex
                              ? Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Container(
                                  height: 5,
                                  width: 6,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusDefault)),
                                ),
                        );
                      }).toList(),
                    ),
                  ]),
                )
              : const SizedBox()
          : MiddleSectionBannerShimmerView(isPharmacy: isPharmacy);
    });
  }
}

class MiddleSectionBannerShimmerView extends StatelessWidget {
  final bool isPharmacy;
  const MiddleSectionBannerShimmerView({super.key, required this.isPharmacy});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(children: [
        Stack(
          children: [
            carousel.CarouselSlider.builder(
              itemCount: 3,
              options: carousel.CarouselOptions(
                height: isPharmacy ? 187 : 135,
                enlargeCenterPage: true,
                disableCenter: true,
                viewportFraction: 0.95,
              ),
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return Container(
                  height: isPharmacy ? 187 : 135,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                );
              },
            ),
          ],
        ),
      ]),
    );

  }
}
