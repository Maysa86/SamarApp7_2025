import 'dart:async';

import '../../order/domain/models/order_model.dart';
import '../../dashboard/widgets/running_order_view_widget.dart';
import '../../order/controllers/order_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../../../common/controllers/theme_controller.dart';
import '../../banner/controllers/banner_controller.dart';
import '../../brands/controllers/brands_controller.dart';
import '../controllers/advertisement_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/all_store_filter_widget.dart';
import '../widgets/cashback_logo_widget.dart';
import '../widgets/cashback_dialog_widget.dart';
import '../widgets/refer_bottom_sheet_widget.dart';
import '../../item/controllers/campaign_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../coupon/controllers/coupon_controller.dart';
import '../../flash_sale/controllers/flash_sale_controller.dart';
import '../../language/controllers/language_controller.dart';
import '../../location/controllers/location_controller.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../item/controllers/item_controller.dart';
import '../../store/controllers/store_controller.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../address/controllers/address_controller.dart';
import 'modules/food_home_screen.dart';
import 'modules/grocery_home_screen.dart';
import 'modules/pharmacy_home_screen.dart';
import 'modules/shop_home_screen.dart';
import '../../parcel/controllers/parcel_controller.dart';
import '../../../helper/address_helper.dart';
import '../../../helper/auth_helper.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../common/widgets/item_view.dart';
import '../../../common/widgets/menu_drawer.dart';
import '../../../common/widgets/paginated_list_view.dart';
import '../../../common/widgets/web_menu_bar.dart';
//import 'web_new_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/module_view.dart';
//import '../../parcel/screens/parcel_category_screen.dart';
//import '../../../helper/route_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Future<void> loadData(bool reload, {bool fromModule = false}) async {
    Get.find<BannerController>().clearBannerList();
    Get.find<CategoryController>().clearCategoryList();
    Get.find<ItemController>().clearItemLists();
    Get.find<StoreController>().resetStoreLists();
    Get.find<CampaignController>().clearCampaigns();
    Get.find<AdvertisementController>().clearAdvertisementList();
    Get.find<FlashSaleController>().clearFlashSale();
    Get.find<LocationController>().syncZoneData();
    Get.find<FlashSaleController>().setEmptyFlashSale(fromModule: fromModule);
     Get.find<BannerController>().getBannerList(reload);

    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
    // await Get.find<BannerController>().getBannerList(reload);
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.grocery) {
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.ecommerce) {
        await Get.find<ItemController>().getFeaturedCategoriesItemList(false, false);
        await  Get.find<FlashSaleController>().getFlashSale(reload, false);
        Get.find<BrandsController>().getBrandList();
      }
      Get.find<BannerController>().getPromotionalBannerList(reload);
      Get.find<ItemController>().getDiscountedItemList(reload, false, 'all');
      Get.find<StoreController>().getStoreList(1, reload);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
    await  Get.find<CategoryController>().getCategoryList(reload);
      await  Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      await  Get.find<CampaignController>().getBasicCampaignList(reload);
      await  Get.find<CampaignController>().getItemCampaignList(reload);
      //  Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      await  Get.find<ItemController>().getPopularItemList(
        true,
        'all',
        false,
        moduleId: Get.find<SplashController>().module?.id,
        reload: true, // ✅ أضف هذا
      );

     // Get.find<StoreController>().getStoreList(1, reload);
     // Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
   await   Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
await      Get.find<ItemController>().getRecommendedItemList(true, 'all', false
        , moduleId: Get.find<SplashController>().module?.id,);


    await  Get.find<StoreController>().getRecommendedStoreList();
   await   Get.find<AdvertisementController>().getAdvertisementList();
    }
    if (AuthHelper.isLoggedIn()) {
      Get.find<StoreController>()
          .getVisitAgainStoreList(fromModule: fromModule);
      await Get.find<ProfileController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<CouponController>().getCouponList();
    }
    Get.find<SplashController>().getModules();
    //N
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (AuthHelper.isLoggedIn()) {
        Get.find<AddressController>().getAddressList();
      }

    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy) {
      Get.find<ItemController>().getBasicMedicine(reload, false);
      Get.find<StoreController>().getFeaturedStoreList();

      await Get.find<ItemController>().getCommonConditions(false);
      if (Get.find<ItemController>().commonConditions!.isNotEmpty) {
        Get.find<ItemController>().getConditionsWiseItem(
            Get.find<ItemController>().commonConditions![0].id!, false);
      }

    }
    if ((Get.find<StoreController>().nearbyStoreList ?? []).isEmpty) {
      Get.find<SplashController>().getModules();
      final address = AddressHelper.getUserAddressFromSharedPref();
      if (address != null) {
        final lat = double.tryParse(address.latitude?.toString() ?? '') ??
            0.0;
        final lng = double.tryParse(address.longitude?.toString() ?? '') ??
            0.0;

        await Get.find<StoreController>().getNearbyStoreList(
            lat, lng, reload: true);

        //Get.find<StoreController>().update(); // ✅ تحديث الـ UI بعد تحميل البيانات
      }
      //  print(
      //      '📍 Address from SharedPref: ${address?.addressType}, lat: ${address
      //          ?.latitude}, lng: ${address?.longitude}');
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _pollingTimer;

  bool searchBgShow = false;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // تحميل البيانات الخاصة بالشاشة الرئيسية
    HomeScreen.loadData(false).then((value) {
      Get.find<SplashController>().getReferBottomSheetStatus();

      if ((Get.find<ProfileController>().userInfoModel?.isValidForDiscount ??
          false) &&
          Get.find<SplashController>().showReferBottomSheet) {
        _showReferBottomSheet();
      }
    });

    // استدعاء بيانات الموقع
    //  if (!ResponsiveHelper.isWeb()) {
    //    Get.find<LocationController>().getZone(
    //     AddressHelper.getUserAddressFromSharedPref()!.latitude,
    //     AddressHelper.getUserAddressFromSharedPref()!.longitude,
    //     false,
    //    updateInAddress: true,
    //   );
    //  }
    if (AuthHelper.isLoggedIn()) {
      // تحميل الطلبات قيد التنفيذ
      Future.delayed(Duration.zero, () {
        Get.find<OrderController>().getRunningOrders(1, isUpdate: true);
      });
      _startPolling();
    }

    // التعامل مع حركة التمرير
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(seconds: 1),
                  () => Get.find<HomeController>().changeFavVisibility());
        }
      } else {
        if (Get.find<HomeController>().showFavButton) {
          Get.find<HomeController>().changeFavVisibility();
          Future.delayed(const Duration(seconds: 1),
                  () => Get.find<HomeController>().changeFavVisibility());
        }
      }
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      Get.find<OrderController>().getRunningOrders(1, isUpdate: true);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _showReferBottomSheet() {
    ResponsiveHelper.isDesktop(context)
        ? Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(22),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: const ReferBottomSheetWidget(),
      ),
      useSafeArea: false,
    ).then((value) =>
        Get.find<SplashController>().saveReferBottomSheetStatus(false))
        : showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: const ReferBottomSheetWidget(),
        );
      },
    ).then((value) =>
        Get.find<SplashController>().saveReferBottomSheetStatus(false));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;

      return GetBuilder<HomeController>(builder: (homeController) {
        return Scaffold(
          appBar:
          ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                splashController.setRefreshing(true);
                await HomeScreen.loadData(false);
                splashController.setRefreshing(false);
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // App Bar
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    surfaceTintColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: _buildAppBarContent(splashController, context),
                  ),
                  // إضافة كود البحث أسفل العنوان
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        // width: Dimensions.webMaxWidth,
                        width: MediaQuery.of(context).size.width * 0.95,
                        margin: const EdgeInsets.only(
                            top: 5,
                            bottom:
                            5), // هام للتحكم في المسافة بين العنوان والبحث
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: InkWell(
                          onTap: () =>
                              Get.toNamed(RouteHelper.getSearchRoute()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 1)
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.search,
                                  size: 25,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Expanded(
                                  child: Text(
                                    Get.find<SplashController>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .showRestaurantText!
                                        ? 'search_food_or_restaurant'.tr
                                        : 'search_item_or_store'.tr,
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // الطلبات الجارية
                  if (splashController.module == null &&
                      splashController.configModel!.module == null &&
                      AuthHelper.isLoggedIn())
                    SliverToBoxAdapter(
                      child: GetBuilder<OrderController>(
                        builder: (orderController) {
                          if (orderController.runningOrderModel == null ||
                              orderController
                                  .runningOrderModel!.orders!.isEmpty) {
                            return const SizedBox();
                          }

                          List<OrderModel> runningOrder =
                          orderController.runningOrderModel!.orders!;
                          List<OrderModel> reversOrder =
                          List.from(runningOrder.reversed);

                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RunningOrderViewWidget(
                              reversOrder: reversOrder,
                              onOrderTap: () {
                                Get.toNamed(RouteHelper.getOrderRoute());
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  // باقي المحتوى
                  SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: !showMobileModule
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (splashController.module != null) ...[
                              if (splashController.module!.moduleType
                                  .toString() ==
                                  AppConstants.grocery)
                                const GroceryHomeScreen()
                              else if (splashController.module!.moduleType
                                  .toString() ==
                                  AppConstants.pharmacy)
                                const PharmacyHomeScreen()
                              else if (splashController.module!.moduleType
                                    .toString() ==
                                    AppConstants.food)
                                  const FoodHomeScreen()
                                else if (splashController.module!.moduleType
                                      .toString() ==
                                      AppConstants.ecommerce)
                                    const ShopHomeScreen(),
                            ]
                          ],
                        )
                            : ModuleView(splashController: splashController),
                      ),
                    ),
                  ),

                  // الفلتر
                  if (!showMobileModule)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                        height: 85,
                        callback: (val) {
                          // يتم تحديث الحالة بناءً على التمرير
                        },
                        child: const AllStoreFilterWidget(),
                      ),
                    ),

                  // قائمة المتاجر
                  SliverToBoxAdapter(
                    child: !showMobileModule
                        ? Center(
                      child: GetBuilder<StoreController>(
                        builder: (storeController) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveHelper.isDesktop(context)
                                  ? 0
                                  : 100,
                            ),
                            child: PaginatedListView(
                              scrollController: _scrollController,
                              totalSize:
                              storeController.storeModel?.totalSize,
                              offset: storeController.storeModel?.offset,
                              onPaginate: (int? offset) async =>
                              await storeController.getStoreList(
                                  offset!, false),
                              itemView: ItemsView(
                                isStore: true,
                                items: null,
                                isFoodOrGrocery: (splashController
                                    .module!.moduleType
                                    .toString() ==
                                    AppConstants.food ||
                                    splashController.module!.moduleType
                                        .toString() ==
                                        AppConstants.grocery),
                                stores:
                                storeController.storeModel?.stores,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          // زر الإجراء العائم
          floatingActionButton: AuthHelper.isLoggedIn() &&
              homeController.cashBackOfferList != null &&
              homeController.cashBackOfferList!.isNotEmpty
              ? homeController.showFavButton
              ? Padding(
            padding: EdgeInsets.only(
                bottom: 50.0,
                right: ResponsiveHelper.isDesktop(context) ? 50 : 0),
            child: InkWell(
              onTap: () => Get.dialog(const CashBackDialogWidget()),
              child: const CashBackLogoWidget(),
            ),
          )
              : null
              : null,
        );
      });
    });
  }

  /// تحميل البيانات بناءً على نوع الـ module
  Future<void> _loadDataBasedOnModule(SplashController splashController,
      bool isPharmacy, bool isGrocery, bool isShop) async {
    if (splashController.module != null) {
      await Get.find<LocationController>().syncZoneData();
      await Get.find<BannerController>().getBannerList(true);
      if (isGrocery) {
        await Get.find<FlashSaleController>().getFlashSale(true, true);
      }
      await Get.find<BannerController>().getPromotionalBannerList(true);
      await Get.find<ItemController>()
          .getDiscountedItemList(true, false, 'all');
      await Get.find<CategoryController>().getCategoryList(true);
      await Get.find<StoreController>().getPopularStoreList(true, 'all', false);
      await Get.find<CampaignController>().getItemCampaignList(true);
      Get.find<CampaignController>().getBasicCampaignList(true);
      await Get.find<ItemController>().getPopularItemList(true, 'all', false);
      await Get.find<StoreController>().getLatestStoreList(true, 'all', false);
      await Get.find<ItemController>().getReviewedItemList(true, 'all', false);
      await Get.find<StoreController>().getStoreList(1, true);
      Get.find<AdvertisementController>().getAdvertisementList();
      if (AuthHelper.isLoggedIn()) {
        await Get.find<ProfileController>().getUserInfo();
        await Get.find<NotificationController>().getNotificationList(true);
        Get.find<CouponController>().getCouponList();
      }
      if (isPharmacy) {
        Get.find<ItemController>().getBasicMedicine(true, true);
        Get.find<ItemController>().getCommonConditions(true);
      }
      if (isShop) {
        await Get.find<FlashSaleController>().getFlashSale(true, true);
        Get.find<ItemController>().getFeaturedCategoriesItemList(true, true);
        Get.find<BrandsController>().getBrandList();
      }
    } else {
      await Get.find<BannerController>().getFeaturedBanner();
      await Get.find<SplashController>().getModules();
      if (AuthHelper.isLoggedIn()) {
        await Get.find<AddressController>().getAddressList();
      }
      await Get.find<StoreController>().getFeaturedStoreList();

    }
  }

  /// محتوى شريط التطبيق
  Widget _buildAppBarContent(
      SplashController splashController, BuildContext context) {
    return Center(
      child: Container(
        width: Dimensions.webMaxWidth,
        height: Get.find<LocalizationController>().isLtr ? 60 : 70,
        color: Theme.of(context).colorScheme.surface,
        child: Row(children: [
          if (splashController.module != null &&
              splashController.configModel!.module == null)
            InkWell(
              onTap: () {
                splashController.removeModule();
                Get.find<StoreController>().resetStoreData();
              },
              child: Image.asset(Images.moduleIcon,
                  height: 25,
                  width: 25,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          if (splashController.module != null &&
              splashController.configModel!.module == null)
            const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: InkWell(
              onTap: () => Get.find<LocationController>()
                  .navigateToLocationScreen('home'),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall,
                  horizontal: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.paddingSizeSmall
                      : 0,
                ),
                child: GetBuilder<LocationController>(
                    builder: (locationController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AuthHelper.isLoggedIn()
                                ? AddressHelper.getUserAddressFromSharedPref()!
                                .addressType!
                                .tr
                                : 'your_location'.tr,
                            style: robotoMedium.copyWith(
                                color: Theme.of(context).textTheme.bodyLarge!.color,
                                fontSize: Dimensions.fontSizeDefault),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(children: [
                            Flexible(
                              child: Text(
                                AddressHelper.getUserAddressFromSharedPref()!
                                    .address!,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(Icons.expand_more,
                                color: Theme.of(context).disabledColor, size: 18),
                          ]),
                        ],
                      );
                    }),
              ),
            ),
          ),
          InkWell(
            child: GetBuilder<NotificationController>(
                builder: (notificationController) {
                  return Stack(children: [
                    Icon(CupertinoIcons.bell,
                        size: 25,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    if (notificationController.hasNotification)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1, color: Theme.of(context).cardColor),
                          ),
                        ),
                      ),
                  ]);
                }),
            onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
        ]),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  Function(bool isPinned)? callback;
  bool isPinned = false;

  SliverDelegate({required this.child, this.height = 50, this.callback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    isPinned = shrinkOffset == maxExtent /*|| shrinkOffset < maxExtent*/;
    callback!(isPinned);
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height ||
        oldDelegate.minExtent != height ||
        child != oldDelegate.child;
  }
}
