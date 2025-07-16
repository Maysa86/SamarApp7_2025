import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../category/controllers/category_controller.dart';
import '../../coupon/controllers/coupon_controller.dart';
import '../../language/controllers/language_controller.dart';
import '../../location/controllers/location_controller.dart';
import '../domain/models/cart_suggested_item_model.dart';
import '../../category/domain/models/category_model.dart';
import '../../item/domain/models/item_model.dart';
import '../domain/models/recommended_product_model.dart';
import '../domain/models/store_banner_model.dart';
import '../domain/models/store_model.dart';
import '../../review/domain/models/review_model.dart';
import '../../location/domain/models/zone_response_model.dart';
import '../../checkout/controllers/checkout_controller.dart';
import '../../../helper/address_helper.dart';
import '../../../helper/date_converter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../home/screens/home_screen.dart';
import '../domain/services/store_service_interface.dart';
import '../../../helper/module_helper.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/app_constants.dart';
import '../domain/repositories/store_repository.dart';
import '../../splash/controllers/splash_controller.dart';

class StoreController extends GetxController implements GetxService {
 // final StoreRepository storeRepo;
//  final storeRepo = Get.find<StoreRepository>();

  final StoreServiceInterface storeServiceInterface;
  final StoreRepository storeRepo;

  StoreController({
    required this.storeRepo,
    required this.storeServiceInterface,
  });


  List<Store>? nearbyStoreList;


  StoreModel? _storeModel;
  StoreModel? get storeModel => _storeModel;

  List<Store>? _popularStoreList;
  List<Store>? get popularStoreList => _popularStoreList;

  List<Store>? _latestStoreList;
  List<Store>? get latestStoreList => _latestStoreList;

  List<Store> _featuredStoreList =[];
  List<Store>? get featuredStoreList => _featuredStoreList;

  List<Store>? _visitAgainStoreList;
  List<Store>? get visitAgainStoreList => _visitAgainStoreList;

  Store? _store;
  Store? get store => _store;

  ItemModel? _storeItemModel;
  ItemModel? get storeItemModel => _storeItemModel;

  ItemModel? _storeSearchItemModel;
  ItemModel? get storeSearchItemModel => _storeSearchItemModel;

  int _categoryIndex = 0;
  int get categoryIndex => _categoryIndex;
//  final StoreRepository storeRepo;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _filterType = 'all';
  String get filterType => _filterType;

  String _storeType = 'all';
  String get storeType => _storeType;

  List<ReviewModel>? _storeReviewList;
  List<ReviewModel>? get storeReviewList => _storeReviewList;

  String _type = 'all';
  String get type => _type;

  String _searchType = 'all';
  String get searchType => _searchType;

  String _searchText = '';
  String get searchText => _searchText;

  bool _currentState = true;
  bool get currentState => _currentState;

  bool _showFavButton = true;
  bool get showFavButton => _showFavButton;

  List<XFile> _pickedPrescriptions = [];
  List<XFile> get pickedPrescriptions => _pickedPrescriptions;

  RecommendedItemModel? _recommendedItemModel;
  RecommendedItemModel? get recommendedItemModel => _recommendedItemModel;

  CartSuggestItemModel? _cartSuggestItemModel;
  CartSuggestItemModel? get cartSuggestItemModel => _cartSuggestItemModel;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<StoreBannerModel>? _storeBanners;
  List<StoreBannerModel>? get storeBanners => _storeBanners;

  List<Store>? _recommendedStoreList;
  List<Store>? get recommendedStoreList => _recommendedStoreList;

  double getRestaurantDistance(LatLng storeLatLng) {
    double distance = 0;
    distance = Geolocator.distanceBetween(
            storeLatLng.latitude,
            storeLatLng.longitude,
            double.parse(
                AddressHelper.getUserAddressFromSharedPref()!.latitude!),
            double.parse(
                AddressHelper.getUserAddressFromSharedPref()!.longitude!)) /
        1000;
    return distance;
  }

  String filteringUrl(String slug) {
    return storeServiceInterface.filterRestaurantLinkUrl(slug, _store!);
  }

  void pickPrescriptionImage(
      {required bool isRemove, required bool isCamera}) async {
    if (isRemove) {
      _pickedPrescriptions = [];
    } else {
      XFile? xFile = await ImagePicker().pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50);
      if (xFile != null) {
        _pickedPrescriptions.add(xFile);
      }
      update();
    }
  }

  void removePrescriptionImage(int index) {
    _pickedPrescriptions.removeAt(index);
    update();
  }

  void changeFavVisibility() {
    _showFavButton = !_showFavButton;
    update();
  }

  void hideAnimation() {
    _currentState = false;
  }

  void showButtonAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      _currentState = true;
      update();
    });
  }

  Future<void> getRestaurantRecommendedItemList(
      int? storeId, bool reload) async {
    if (reload) {
      _storeModel = null;
      update();
    }
    RecommendedItemModel? recommendedItemModel =
        await storeServiceInterface.getStoreRecommendedItemList(storeId);
    if (recommendedItemModel != null) {
      _recommendedItemModel = recommendedItemModel;
    }
    update();
  }

  //Future<void> getNearbyStoresWithoutModule({bool reload = false}) async {
   // if (nearbyStoreList != null && !reload) return;

   // nearbyStoreList = null;
  //  update();

  //  List<Store>? response = await storeRepo.getNearbyStoresWithoutModule(offset: 1, limit: 10);

   // nearbyStoreList = response;
 //   update();
 // }


  Future<void> getCartStoreSuggestedItemList(int? storeId) async {
    CartSuggestItemModel? cartSuggestItemModel =
        await storeServiceInterface.getCartStoreSuggestedItemList(
            storeId,
            Get.find<LocalizationController>().locale.languageCode,
            ModuleHelper.getModule(),
            ModuleHelper.getCacheModule()?.id,
            ModuleHelper.getModule()?.id);
    if (cartSuggestItemModel != null) {
      _cartSuggestItemModel = cartSuggestItemModel;
    }
    update();
  }

  Future<void> getStoreBannerList(int? storeId) async {
    List<StoreBannerModel>? storeBanners =
        await storeServiceInterface.getStoreBannerList(storeId);
    if (storeBanners != null) {
      _storeBanners = [];
      _storeBanners!.addAll(storeBanners);
    }
    update();
  }
//

  Future<void> getFeaturedStoreList() async {
    print("📣 تم استدعاء getFeaturedStoreList");

    try {
      Response response = await storeServiceInterface.getFeaturedStoreList();

      if (response.statusCode == 200 && response.body['stores'] != null) {
        _featuredStoreList = [];

        List<dynamic> stores = response.body['stores'];
        final splash = Get.find<SplashController>();

        if (splash.module != null) {
          final List<Modules> moduleList = storeServiceInterface.moduleList();

          for (var storeData in stores) {
            final store = Store.fromJson(storeData);
            final matchedModule = moduleList.firstWhere(
                  (m) => m.id == store.moduleId && m.pivot?.zoneId == store.zoneId,
              orElse: () => Modules(), // Module غير مطابق
            );

            if (matchedModule.id != null) {
              _featuredStoreList.add(store);
            }
          }
        } else {
          // إذا لم يكن هناك موديول، أضف كل المتاجر
          _featuredStoreList = stores.map((s) => Store.fromJson(s)).toList();
        }

        print("✅ عدد المتاجر المميزة: ${_featuredStoreList.length}");
        update(); // مهم جداً لتحديث الواجهة
      } else {
        print("❌ فشل تحميل المتاجر المميزة أو البيانات غير متوفرة");
      }
    } catch (e, s) {
      print("⚠️ خطأ في getFeaturedStoreList: $e\n$s");
    }
  }

  bool _nearbyLoaded = false;

  Future<void> getNearbyStoreList(double lat, double lng, {bool reload = false}) async {
    if (_nearbyLoaded && !reload) return;
    _nearbyLoaded = true;

    print("🟢 جلب المتاجر القريبة مرة واحدة فقط");

    try {
      Response response = await storeServiceInterface.getNearbyStoreList(
        1, 10, lat ?? 0.0, lng ?? 0.0,
      );

      if (response.statusCode == 200 && response.body['stores'] != null) {
        nearbyStoreList = [];

        List<dynamic> stores = response.body['stores'];
        final splash = Get.find<SplashController>();

        if (splash.module != null) {
          final List<Modules> moduleList = storeServiceInterface.moduleList();

          for (var storeData in stores) {
            final store = Store.fromJson(storeData);
            final matchedModule = moduleList.firstWhere(
                  (m) => m.id == store.moduleId && m.pivot?.zoneId == store.zoneId,
              orElse: () => Modules(),
            );

            if (matchedModule.id != null) {
              nearbyStoreList!.add(store);
            }
          }
        } else {
          nearbyStoreList = stores.map((s) => Store.fromJson(s)).toList();
        }

        print("✅ عدد المتاجر القريبة: ${nearbyStoreList?.length}");
        update();
      } else {
        print("❌ فشل تحميل المتاجر القريبة أو البيانات غير متوفرة");
      }
    } catch (e, s) {
      print("⚠️ خطأ في getNearbyStoreList: $e\n$s");
    }
  }



  // Future<void> getNearbyStoreList(double? latitude, double? longitude, {bool reload = false}) async {
   // if (reload) {
   //   _storeModel = null;
   //   update();
 //   }
   // final address = AddressHelper.getUserAddressFromSharedPref();
  //  final lat = latitude ?? (address?.latitude != null ? double.tryParse(address!.latitude.toString()) ?? 0.0 : 0.0);
 //   final lng = longitude ?? (address?.longitude != null ? double.tryParse(address!.longitude.toString()) ?? 0.0 : 0.0);
   // StoreModel? storeModel = await storeRepo.getNearbyStores(1, 10, lat, lng);
 //   if (storeModel != null) {
     // _storeModel = storeModel;
     // nearbyStoreList = storeModel.stores; // ✅ هذا السطر المهم
    //}
    //update();
    //print('✅ nearbyStoreList عدد المتاجر: ${nearbyStoreList?.length}');

  //}




  //
  Future<void> getStoreList(int offset, bool reload) async {
    if (reload) {
      _storeModel = null;
      update();
    }
    StoreModel? storeModel = await storeServiceInterface.getStoreList(
        offset, _filterType, _storeType);
    if (storeModel != null) {
      if (offset == 1) {
        _storeModel = storeModel;
      } else {
        _storeModel!.totalSize = storeModel.totalSize;
        _storeModel!.offset = storeModel.offset;
        _storeModel!.stores!.addAll(storeModel.stores!);
      }
      update();
    }
  }

  void setFilterType(String type) {
    _filterType = type;
    getStoreList(1, true);
  }

  void setStoreType(String type) {
    _storeType = type;
    getStoreList(1, true);
  }

  void resetStoreData() {
    _filterType = 'all';
    _storeType = 'all';
  }

  Future<void> getPopularStoreList(
      bool reload, String type, bool notify) async {
    print('📍 getPopularStoreList called with type: $type'); // << هنا
    _type = type;
    if (reload) {
      _popularStoreList = null;
    }
    if (notify) {
      update();
    }
    if (_popularStoreList == null || reload) {
      List<Store>? popularStoreList =
          await storeServiceInterface.getPopularStoreList(type);
      if (popularStoreList != null) {
        _popularStoreList = [];
        _popularStoreList!.addAll(popularStoreList);
      }
      update();
    }
  }

  Future<void> getLatestStoreList(bool reload, String type, bool notify) async {
    _type = type;
    if (reload) {
      _latestStoreList = null;
    }
    if (notify) {
      update();
    }
    if (_latestStoreList == null || reload) {
      List<Store>? latestStoreList =
          await storeServiceInterface.getLatestStoreList(type);
      if (latestStoreList != null) {
        _latestStoreList = [];
        _latestStoreList!.addAll(latestStoreList);
      }
      update();
    }
  }



  Future<void> getVisitAgainStoreList({bool fromModule = false}) async {}

  void setCategoryList() {
    if (Get.find<CategoryController>().categoryList != null && _store != null) {
      _categoryList = [];
      _categoryList!.add(CategoryModel(id: 0, name: 'all'.tr));
      for (var category in Get.find<CategoryController>().categoryList!) {
        if (_store!.categoryIds!.contains(category.id)) {
          _categoryList!.add(category);
        }
      }
    }
  }

  Future<void> initCheckoutData(int? storeId) async {}

  Future<Store?> getStoreDetails(Store store, bool fromModule,
      {bool fromCart = false, String slug = ''}) async {
    _categoryIndex = 0;
    if (store.name != null) {
      _store = store;
    } else {
      _isLoading = true;
      _store = null;
      Store? storeDetails = await storeServiceInterface.getStoreDetails(
          store.id.toString(),
          fromCart,
          slug,
          Get.find<LocalizationController>().locale.languageCode,
          ModuleHelper.getModule(),
          ModuleHelper.getCacheModule()?.id,
          ModuleHelper.getModule()?.id);
      if (storeDetails != null) {
        _store = storeDetails;
        Get.find<CheckoutController>().initializeTimeSlot(_store!);
        if (!fromCart && slug.isEmpty) {
          Get.find<CheckoutController>().getDistanceInKM(
            LatLng(
              double.parse(
                  AddressHelper.getUserAddressFromSharedPref()!.latitude!),
              double.parse(
                  AddressHelper.getUserAddressFromSharedPref()!.longitude!),
            ),
            LatLng(double.parse(_store!.latitude!),
                double.parse(_store!.longitude!)),
          );
        }
        if (slug.isNotEmpty) {
          await Get.find<LocationController>().setStoreAddressToUserAddress(
              LatLng(double.parse(_store!.latitude!),
                  double.parse(_store!.longitude!)));
        }
        if (fromModule) {
          HomeScreen.loadData(true);
        } else {
          Get.find<CheckoutController>().clearPrevData();
        }
      }
      Get.find<CheckoutController>().setOrderType(
        _store != null
            ? _store!.delivery!
                ? 'delivery'
                : 'take_away'
            : 'delivery',
        notify: false,
      );
      _isLoading = false;
      update();
    }
    return _store;
  }

  Future<void> getRecommendedStoreList() async {
    _recommendedStoreList = null;
    List<Store>? recommendedStoreList =
        await storeServiceInterface.getRecommendedStoreList();
    if (recommendedStoreList != null) {
      _recommendedStoreList = [];
      _recommendedStoreList!.addAll(recommendedStoreList);
    }
    update();
  }

  Future<void> getStoreItemList(
      int? storeID, int offset, String type, bool notify) async {
    if (offset == 1 || _storeItemModel == null) {
      _type = type;
      _storeItemModel = null;
      if (notify) {
        update();
      }
    }
    ItemModel? storeItemModel = await storeServiceInterface.getStoreItemList(
      storeID,
      offset,
      (_store != null && _store!.categoryIds!.isNotEmpty && _categoryIndex != 0)
          ? _categoryList![_categoryIndex].id
          : 0,
      type,
    );
    if (storeItemModel != null) {
      if (offset == 1) {
        _storeItemModel = storeItemModel;
      } else {
        _storeItemModel!.items!.addAll(storeItemModel.items!);
        _storeItemModel!.totalSize = storeItemModel.totalSize;
        _storeItemModel!.offset = storeItemModel.offset;
      }
    }
    update();
  }

  Future<void> getStoreSearchItemList(
      String searchText, String? storeID, int offset, String type) async {
    if (searchText.isEmpty) {
      showCustomSnackBar('write_item_name'.tr);
    } else {}
  }

  void changeSearchStatus({bool isUpdate = true}) {
    _isSearching = !_isSearching;
    if (isUpdate) {
      update();
    }
  }

  void initSearchData() {
    _storeSearchItemModel = ItemModel(items: []);
    _searchText = '';
  }

  void setCategoryIndex(int index, {bool itemSearching = false}) {
    _categoryIndex = index;
    if (itemSearching) {
      _storeSearchItemModel = null;
      getStoreSearchItemList(_searchText, _store!.id.toString(), 1, type);
    } else {
      _storeItemModel = null;
      getStoreItemList(_store!.id, 1, Get.find<StoreController>().type, false);
    }
    update();
  }

  bool isStoreClosed(bool today, bool active, List<Schedules>? schedules) {
    if (!active) {
      return true;
    }
    DateTime date = DateTime.now();
    if (!today) {
      date = date.add(const Duration(days: 1));
    }
    int weekday = date.weekday;
    if (weekday == 7) {
      weekday = 0;
    }
    for (int index = 0; index < schedules!.length; index++) {
      if (weekday == schedules[index].day) {
        return false;
      }
    }
    return true;
  }

  bool isStoreOpenNow(bool active, List<Schedules>? schedules) {
    if (isStoreClosed(true, active, schedules)) {
      return false;
    }
    int weekday = DateTime.now().weekday;
    if (weekday == 7) {
      weekday = 0;
    }
    for (int index = 0; index < schedules!.length; index++) {}
    return false;
  }

  bool isOpenNow(Store store) => store.open == 1 && store.active!;

  double? getDiscount(Store store) =>
      store.discount != null ? store.discount!.discount : 0;

  String? getDiscountType(Store store) =>
      store.discount != null ? store.discount!.discountType : 'percent';

  void shareStore() {
    if (ResponsiveHelper.isDesktop(Get.context)) {
      String shareUrl =
          '${AppConstants.webHostedUrl}${filteringUrl(store!.slug ?? '')}';

      Clipboard.setData(ClipboardData(text: shareUrl));
      showCustomSnackBar('store_url_copied'.tr, isError: false);
    } else {
      String shareUrl =
          '${AppConstants.webHostedUrl}${filteringUrl(store!.slug ?? '')}';
      Share.share(shareUrl);
    }
  }
  void resetStoreLists() {
    _popularStoreList = null;
    _latestStoreList = null;
    _recommendedStoreList = null;
    _featuredStoreList = [];
    _visitAgainStoreList = null;
    _storeModel = null;
    _storeItemModel = null;
    _storeSearchItemModel = null;
    _storeBanners = null;
    nearbyStoreList=[];
    update();
  }

}
