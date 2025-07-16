import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../language/controllers/language_controller.dart';
import '../../../store/controllers/store_controller.dart';
import '../../../store/domain/models/store_model.dart';
import '../components/popular_store_card_widget.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../common/widgets/title_widget.dart';
import 'widgets/arrow_icon_button.dart';

class WebPopularStoresView extends StatefulWidget {
  const WebPopularStoresView({super.key});

  @override
  State<WebPopularStoresView> createState() => _WebPopularStoresViewState();
}

class _WebPopularStoresViewState extends State<WebPopularStoresView> {

  ScrollController scrollController = ScrollController();
  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    scrollController.addListener(_checkScrollPosition);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    setState(() {
      if (scrollController.position.pixels <= 0) {
        showBackButton = false;
      } else {
        showBackButton = true;
      }

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        showForwardButton = false;
      } else {
        showForwardButton = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      child: GetBuilder<StoreController>(builder: (storeController) {
        List<Store>? storeList = storeController.popularStoreList;

        if(storeList != null && storeList.length > 3 && isFirstTime){
          showForwardButton = true;
          isFirstTime = false;
        }

          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: TitleWidget(
                title: 'popular_stores'.tr,
                onTap: () => Get.toNamed(RouteHelper.getAllStoreRoute('popular')),
              ),
            ),

            Stack(children: [

              SizedBox(
                height: 210, width: Get.width,
                child: storeList != null ? ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: storeList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeDefault,
                        right: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeDefault : 0,
                        bottom: Dimensions.paddingSizeExtraSmall,
                      ),
                      child: PopularStoreCard(
                        store: storeList[index],
                      ),
                    );
                  },
                ) : const PopularStoreShimmer(),
              ),

              if(showBackButton)
                Positioned(
                  top: 90, left: 0,
                  child: ArrowIconButton(
                    isRight: false,
                    onTap: () => scrollController.animateTo(scrollController.offset - Dimensions.webMaxWidth,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                  ),
                ),

              if(showForwardButton)
                Positioned(
                  top: 90, right: 0,
                  child: ArrowIconButton(
                    onTap: () => scrollController.animateTo(scrollController.offset + Dimensions.webMaxWidth,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                  ),
                ),

            ]),

          ]);
        }
      ),
    );
  }
}

class PopularStoreShimmer extends StatelessWidget {
  const PopularStoreShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: ResponsiveHelper.isDesktop(context) ? 315 : 260,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                    ),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 87,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 100,
                                      color: Colors.grey[300],
                                    ),
                                    Container(
                                      height: 5,
                                      width: 100,
                                      color: Colors.grey[300],
                                    ),
                                    Container(
                                      height: 5,
                                      width: 100,
                                      color: Colors.grey[300],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        );
      },
    );
  }
}

