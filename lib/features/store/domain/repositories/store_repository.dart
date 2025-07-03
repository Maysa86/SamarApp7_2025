import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../language/controllers/language_controller.dart';
import '../../../../helper/module_helper.dart';
import '../../../../api/api_client.dart';
import '../../../../common/models/module_model.dart';
import '../../../../helper/address_helper.dart';
import '../../../../helper/header_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../address/domain/models/address_model.dart';
import '../../../item/domain/models/item_model.dart';
import '../../../splash/controllers/splash_controller.dart';
import '../models/cart_suggested_item_model.dart';
import '../models/recommended_product_model.dart';
import '../models/store_banner_model.dart';
import '../models/store_model.dart';
import 'store_repository_interface.dart';

class StoreRepository implements StoreRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  StoreRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future getList(
      {int? offset,
        int limit = 10,
      bool isStoreList = false,
      String? filterBy,
      bool isPopularStoreList = false,
      String? type,
      bool isLatestStoreList = false,
      bool isFeaturedStoreList = false,
      bool isVisitAgainStoreList = false,
      bool isStoreRecommendedItemList = false,
      int? storeId,
      bool isStoreBannerList = false,
      bool isRecommendedStoreList = false}) async {
    if (isStoreList) {
      return await _getStoreList(offset!, filterBy!, type!);
    } else if (isPopularStoreList) {
      return await _getPopularStoreList(type!);
    } else if (isLatestStoreList) {
      return await _getLatestStoreList(type!);
    } else if (isFeaturedStoreList) {
      return await _getFeaturedStoreList();
    } else if (isVisitAgainStoreList) {
      return await _getVisitAgainStoreList();
    } else if (isStoreRecommendedItemList) {
      return await _getStoreRecommendedItemList(storeId);
    } else if (isStoreBannerList) {
      return await _getStoreBannerList(storeId);
    } else if (isRecommendedStoreList) {
      return await _getRecommendedStoreList();
    }
  }
  Future<Response> _getFeaturedStoreList() async {
    return await apiClient.getData(
      '${AppConstants.storefeaturedUri}?offset=1&limit=50',
      // '${AppConstants.storeUri}?offset=1&limit=50',
      headers: Get.find<SplashController>().module == null &&
          Get.find<SplashController>().configModel!.module == null
          ? HeaderHelper.featuredHeader()
          : null,
    );
  }

/*  Future<StoreModel?> getNearbyStores(int offset, int limit, double latitude, double longitude) async {
    try {
      final uri = '${AppConstants.storeNearbyUri}?offset=$offset'
          '&limit=$limit'
          '&latitude=$latitude'
          '&longitude=$longitude'
          '&filter=nearby'
          '&store_type=all';

      final hasNoModule = Get.find<SplashController>().module == null &&
          Get.find<SplashController>().configModel?.module == null;

      final response = await apiClient.getData(
        uri,
        headers: hasNoModule ? HeaderHelper.featuredHeader() : null,
      );
      print('📡 nearbyStore response status: ${response.statusCode}');
      print('📦 response.body: ${response.body}');
      if (response.statusCode == 200 && response.body != null) {
        return StoreModel.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('❌ Error loading nearby stores: $e');
      return null;
    }
  } */
  @override
  Future<Response> getNearbyStoreList(int offset, int limit, double latitude, double longitude) async {
    return await apiClient.getData(
      '${AppConstants.storeNearbyUri}/offset=$offset'
          '&limit=$limit'
          '&latitude=$latitude'
          '&longitude=$longitude'
          '&filter=nearby'
          '&store_type=all',
      headers: Get.find<SplashController>().module == null &&
          Get.find<SplashController>().configModel!.module == null
          ? HeaderHelper.featuredHeader()
          : null,
    );
  }


  Future<StoreModel?> _getStoreList(int offset, String filterBy, String storeType) async {
    StoreModel? storeModel;
    final address = AddressHelper.getUserAddressFromSharedPref();
    final moduleId =  ModuleHelper.getModule()?.id;

    final headers = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      address?.zoneIds,
      address?.areaIds,
      Get.locale?.languageCode ?? 'en',
      moduleId,
      address?.latitude,
      address?.longitude,
      setHeader: false,
    );

    Response response = await apiClient.getData(
      '${AppConstants.storeUri}/$filterBy?store_type=$storeType&offset=$offset&limit=12',
      headers: headers,
    );

    if (response.statusCode == 200) {
      storeModel = StoreModel.fromJson(response.body);
    } else {
      print('❌ Failed to fetch store list. Status code: ${response.statusCode}');
      print('❌ Response body: ${response.body}');
    }

    return storeModel;
  }



  Future<List<Store>?> _getPopularStoreList(String type, {int offset = 1, int limit = 10}) async {
    List<Store>? popularStoreList;

    final addressModel = AddressHelper.getUserAddressFromSharedPref();
    final splashController = Get.find<SplashController>();
    final moduleId = splashController.module?.id;

    final headers = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      addressModel?.zoneIds,
      addressModel?.areaIds,
      Get.find<LocalizationController>().locale.languageCode,
      moduleId,
      addressModel?.latitude,
      addressModel?.longitude,
      setHeader: false,
    );

    Response response = await apiClient.getData(
      '${AppConstants.popularStoreUri}?type=$type&offset=$offset&limit=$limit',
      headers: headers,
    );

    if (response.statusCode == 200) {
      popularStoreList = [];
      response.body['stores']
          .forEach((store) => popularStoreList!.add(Store.fromJson(store)));
    }

    return popularStoreList;
  }




  Future<List<Store>?> _getLatestStoreList(String type, {int offset = 1, int limit = 10}) async {
    List<Store>? latestStoreList;

    Response response = await apiClient.getData(
        '${AppConstants.latestStoreUri}?type=$type&offset=$offset&limit=$limit'
    );

    if (response.statusCode == 200) {
      latestStoreList = [];
      response.body['stores']
          .forEach((store) => latestStoreList!.add(Store.fromJson(store)));
    }

    return latestStoreList;
  }



  Future<Response> _getVisitAgainStoreList() async {
    return await apiClient.getData(AppConstants.visitAgainStoreUri);
  }

  @override
  Future<Store?> getStoreDetails(
      String storeID,
      bool fromCart,
      String slug,
      String languageCode,
      ModuleModel? module,
      int? cacheModuleId,
      int? moduleId) async {
    Store? store;
    Map<String, String>? header;
    if (fromCart) {
      AddressModel? addressModel = AddressHelper.getUserAddressFromSharedPref();
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        addressModel?.zoneIds,
        addressModel?.areaIds,
        languageCode,
        module == null ? cacheModuleId : moduleId,
        addressModel?.latitude,
        addressModel?.longitude,
        setHeader: false,
      );
    }
    if (slug.isNotEmpty) {
      header = apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        [],
        [],
        languageCode,
        0,
        '',
        '',
        setHeader: false,
      );
    }
    Response response = await apiClient.getData(
        '${AppConstants.storeDetailsUri}${slug.isNotEmpty ? slug : storeID}',
        headers: header);
    if (response.statusCode == 200) {
      store = Store.fromJson(response.body);
    }
    return store;
  }

  @override
  Future<ItemModel?> getStoreItemList(
      int? storeID, int offset, int? categoryID, String type) async {
    ItemModel? storeItemModel;
    Response response = await apiClient.getData(
        '${AppConstants.storeItemUri}?store_id=$storeID&category_id=$categoryID&offset=$offset&limit=13&type=$type');
    if (response.statusCode == 200) {
      storeItemModel = ItemModel.fromJson(response.body);
    }
    return storeItemModel;
  }

  @override
  Future<ItemModel?> getStoreSearchItemList(String searchText, String? storeID,
      int offset, String type, int? categoryID) async {
    ItemModel? storeSearchItemModel;
    Response response = await apiClient.getData(
        '${AppConstants.searchUri}items/search?store_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type&category_id=${categoryID ?? ''}');
    if (response.statusCode == 200) {
      storeSearchItemModel = ItemModel.fromJson(response.body);
    }
    return storeSearchItemModel;
  }

  Future<RecommendedItemModel?> _getStoreRecommendedItemList(
      int? storeId) async {
    RecommendedItemModel? recommendedItemModel;
    Response response = await apiClient.getData(
        '${AppConstants.storeRecommendedItemUri}?store_id=$storeId&offset=1&limit=50');
    if (response.statusCode == 200) {
      recommendedItemModel = RecommendedItemModel.fromJson(response.body);
    }
    return recommendedItemModel;
  }

  @override
  Future<CartSuggestItemModel?> getCartStoreSuggestedItemList(
      int? storeId,
      String languageCode,
      ModuleModel? module,
      int? cacheModuleId,
      int? moduleId) async {
    CartSuggestItemModel? cartSuggestItemModel;
    AddressModel? addressModel = AddressHelper.getUserAddressFromSharedPref();
    Map<String, String> header = apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token),
      addressModel?.zoneIds,
      addressModel?.areaIds,
      languageCode,
      module == null ? cacheModuleId : moduleId,
      addressModel?.latitude,
      addressModel?.longitude,
      setHeader: false,
    );
    Response response = await apiClient.getData(
        '${AppConstants.cartStoreSuggestedItemsUri}?recommended=1&store_id=$storeId&offset=1&limit=50',
        headers: header);
    if (response.statusCode == 200) {
      cartSuggestItemModel = CartSuggestItemModel.fromJson(response.body);
    }
    return cartSuggestItemModel;
  }

  Future<List<StoreBannerModel>?> _getStoreBannerList(int? storeId) async {
    List<StoreBannerModel>? storeBanners;
    Response response =
        await apiClient.getData('${AppConstants.storeBannersUri}$storeId');
    if (response.statusCode == 200) {
      storeBanners = [];
      response.body.forEach(
          (banner) => storeBanners!.add(StoreBannerModel.fromJson(banner)));
    }
    return storeBanners;
  }

  Future<List<Store>?> _getRecommendedStoreList() async {
    List<Store>? recommendedStoreList;
    Response response =
        await apiClient.getData(AppConstants.recommendedStoreUri);
    if (response.statusCode == 200) {
      recommendedStoreList = [];
      response.body['stores']
          .forEach((store) => recommendedStoreList!.add(Store.fromJson(store)));
    }
    return recommendedStoreList;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
