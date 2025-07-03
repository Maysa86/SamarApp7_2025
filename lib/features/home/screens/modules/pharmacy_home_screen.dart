import 'package:flutter/material.dart';
import '../../widgets/bad_weather_widget.dart';
import '../../widgets/highlight_widget.dart';
import '../../widgets/views/product_with_categories_view.dart';
import '../../widgets/views/best_store_nearby_view.dart';
import '../../widgets/views/common_condition_view.dart';
import '../../widgets/views/middle_section_banner_view.dart';
import '../../widgets/views/new_on_mart_view.dart';
import '../../widgets/views/promotional_banner_view.dart';
import '../../widgets/banner_view.dart';
import '../../widgets/views/category_view.dart';

class PharmacyHomeScreen extends StatelessWidget {
  const PharmacyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isLoggedIn = AuthHelper.isLoggedIn();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        child: const Column(
          children: [
            BadWeatherWidget(),
            BannerView(isFeatured: false),
            SizedBox(height: 12),
          ],
        ),
      ),

      const CategoryView(),
      // isLoggedIn ? const VisitAgainView() : const SizedBox(),
      const ProductWithCategoriesView(),
      const HighlightWidget(),
      const MiddleSectionBannerView(),
      const BestStoreNearbyView(),
      // const JustForYouView(),
      const NewOnMartView(isShop: false, isPharmacy: true, isNewStore: true),
      const CommonConditionView(),
      const PromotionalBannerView(),
    ]);
  }
}
