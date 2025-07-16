import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/controllers/theme_controller.dart';
import '../../widgets/highlight_widget.dart';
import '../../widgets/views/category_view.dart';
import '../../widgets/bad_weather_widget.dart';
import '../../widgets/views/best_reviewed_item_view.dart';
import '../../widgets/views/best_store_nearby_view.dart';
import '../../widgets/views/item_that_you_love_view.dart';
import '../../widgets/views/most_popular_item_view.dart';
import '../../widgets/views/new_on_mart_view.dart';
import '../../widgets/views/special_offer_view.dart';
import '../../widgets/banner_view.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        decoration: Get.find<ThemeController>().darkTheme
            ? null
            : const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage(Images.foodModuleBannerBg),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: const Column(
          children: [
            BadWeatherWidget(),
            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),

      const CategoryView(),
      // isLoggedIn ? const VisitAgainView(fromFood: true) : const SizedBox(),
      const SpecialOfferView(isFood: true, isShop: false),
    //  const HighlightWidget(),
      //const BestReviewItemView(),
      const BestStoreNearbyView(),
      const ItemThatYouLoveView(forShop: false),
      const MostPopularItemView(isFood: true, isShop: false),
      // const JustForYouView(),
      const NewOnMartView(isNewStore: true, isPharmacy: false, isShop: false),
    ]);
  }
}
