import '../../../common/widgets/custom_ink_well.dart';
import '../../store/controllers/store_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../favourite/controllers/favourite_controller.dart';
import '../../../common/models/module_model.dart';
import '../../store/domain/models/store_model.dart';
import '../../../helper/auth_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../../common/widgets/custom_image.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../common/widgets/discount_tag.dart';
import '../../../common/widgets/not_available_widget.dart';
import '../../../common/widgets/rating_bar.dart';
import '../../../common/widgets/title_widget.dart';
import '../../store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
class PopularStoreView extends StatelessWidget {
  final bool isPopular;
  final bool isFeatured;

  const PopularStoreView({
    super.key,
    required this.isPopular,
    required this.isFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(
      builder: (storeController) {
        List<Store>? storeList = isFeatured
            ? storeController.featuredStoreList
            : isPopular
            ? storeController.popularStoreList
            : storeController.latestStoreList;

        if (storeList == null || storeList.isEmpty) {
          return const SizedBox();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: TitleWidget(
                title: isFeatured
                    ? 'featured_stores'.tr
                    : isPopular
                    ? Get.find<SplashController>()
                    .configModel!
                    .moduleConfig!
                    .module!
                    .showRestaurantText!
                    ? 'popular_restaurants'.tr
                    : 'popular_stores'.tr
                    : '${'new_on'.tr} ${AppConstants.appName}',
                onTap: () => Get.toNamed(
                  RouteHelper.getAllStoreRoute(
                    isFeatured ? 'featured' : isPopular ? 'popular' : 'latest',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                controller: ScrollController(),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding:
                const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                itemCount: storeList.length > 10 ? 10 : storeList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 5), // تم تقليل المسافة بين المتاجر هنا
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.only(
                          top: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                        BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.15),
                            blurRadius: 7,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: CustomInkWell(
                        onTap: () {
                          if (isFeatured &&
                              Get.find<SplashController>().moduleList !=
                                  null) {
                            for (ModuleModel module
                            in Get.find<SplashController>().moduleList!) {
                              if (module.id == storeList[index].moduleId) {
                                Get.find<SplashController>()
                                    .setModule(module);
                                break;
                              }
                            }
                          }
                          Get.toNamed(
                            RouteHelper.getStoreRoute(
                                id: storeList[index].id,
                                page: isFeatured ? 'module' : 'store'),
                            arguments: StoreScreen(
                              store: storeList[index],
                              fromModule: isFeatured,
                            ),
                          );
                        },
                        radius: Dimensions.radiusSmall,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(
                                        Dimensions.radiusSmall),
                                  ),
                                  child: CustomImage(
                                    image:
                                    '${storeList[index].coverPhotoFullUrl}',
                                    height: 70,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                DiscountTag(
                                  discount: storeController
                                      .getDiscount(storeList[index]),
                                  discountType: storeController
                                      .getDiscountType(storeList[index]),
                                  freeDelivery:
                                  storeList[index].freeDelivery,
                                ),
                                storeController
                                    .isOpenNow(storeList[index])
                                    ? const SizedBox()
                                    : const NotAvailableWidget(isStore: true),
                                Positioned(
                                  top: Dimensions.paddingSizeExtraSmall,
                                  right: Dimensions.paddingSizeExtraSmall,
                                  child:
                                  GetBuilder<FavouriteController>(
                                    builder: (favouriteController) {
                                      bool isWished = favouriteController
                                          .wishStoreIdList
                                          .contains(storeList[index].id);
                                      return InkWell(
                                        onTap: () {
                                          if (AuthHelper.isLoggedIn()) {
                                            isWished
                                                ? favouriteController
                                                .removeFromFavouriteList(
                                                storeList[index].id,
                                                true)
                                                : favouriteController
                                                .addToFavouriteList(
                                                null,
                                                storeList[index].id,
                                                true);
                                          } else {
                                            showCustomSnackBar(
                                                'you_are_not_logged_in'.tr);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(
                                              Dimensions
                                                  .paddingSizeExtraSmall),
                                          decoration: BoxDecoration(
                                            color:
                                            Theme.of(context).cardColor,
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.radiusSmall),
                                          ),
                                          child: Icon(
                                            isWished
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 15,
                                            color: isWished
                                                ? Theme.of(context)
                                                .primaryColor
                                                : Theme.of(context)
                                                .disabledColor,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                    Dimensions.paddingSizeExtraSmall),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      storeList[index].name ?? '',
                                      style: robotoMedium.copyWith(
                                          fontSize:
                                          Dimensions.fontSizeSmall),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                        height: Dimensions
                                            .paddingSizeExtraSmall),
                                    Text(
                                      storeList[index].address ?? '',
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions
                                            .fontSizeExtraSmall,
                                        color: Theme.of(context)
                                            .disabledColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                        height: Dimensions
                                            .paddingSizeExtraSmall),
                                    RatingBar(
                                      rating: storeList[index].avgRating,
                                      ratingCount:
                                      storeList[index].ratingCount,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
