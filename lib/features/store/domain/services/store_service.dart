import 'package:get/get.dart';
import '../../../splash/controllers/splash_controller.dart';
import '../models/cart_suggested_item_model.dart';
import '../../../item/domain/models/item_model.dart';
import '../../../../common/models/module_model.dart';
import '../models/recommended_product_model.dart';
import '../models/store_banner_model.dart';
import '../models/store_model.dart';
import '../../../location/domain/models/zone_response_model.dart';
import '../repositories/store_repository_interface.dart';
import 'store_service_interface.dart';
import '../../../../helper/address_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../helper/module_helper.dart';
class StoreService implements StoreServiceInterface {
  final StoreRepositoryInterface storeRepositoryInterface;
  StoreService({required this.storeRepositoryInterface});

  @override
  Future<StoreModel?> getStoreList(int offset, String filterBy, String storeType) async {
    final moduleId =  ModuleHelper.getModule()?.id.toString() ?? 'unknown';

    // print('🚀 [StoreService] getStoreList called with: offset=$offset, filterBy=$filterBy, storeType=$moduleId');

    return await storeRepositoryInterface.getList(
      offset: offset,
      isStoreList: true,
      filterBy: filterBy,
      type: moduleId,
    );
  }



  @override
  Future<List<Store>?> getPopularStoreList(String type) async {
    return await storeRepositoryInterface.getList(
        isPopularStoreList: true, type: type);
  }

  @override
  Future<List<Store>?> getLatestStoreList(String type) async {
    return await storeRepositoryInterface.getList(
        isLatestStoreList: true, type: type);
  }

  @override
  Future<Response> getFeaturedStoreList() async {
    return await storeRepositoryInterface.getList(isFeaturedStoreList: true);
  }

  @override
  Future<Response> getVisitAgainStoreList() async {
    return await storeRepositoryInterface.getList(isVisitAgainStoreList: true);
  }
  @override
  Future<Response> getNearbyStoreList(int offset, int limit, double lat, double lng) async {
    return await storeRepositoryInterface.getNearbyStoreList(offset, limit, lat, lng);
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
    return await storeRepositoryInterface.getStoreDetails(
        storeID, fromCart, slug, languageCode, module, cacheModuleId, moduleId);
  }

  @override
  Future<ItemModel?> getStoreItemList(
      int? storeID, int offset, int? categoryID, String type) async {
    return await storeRepositoryInterface.getStoreItemList(
        storeID, offset, categoryID, type);
  }

  @override
  Future<ItemModel?> getStoreSearchItemList(String searchText, String? storeID,
      int offset, String type, int? categoryID) async {
    return await storeRepositoryInterface.getStoreSearchItemList(
        searchText, storeID, offset, type, categoryID);
  }

  @override
  Future<RecommendedItemModel?> getStoreRecommendedItemList(
      int? storeId) async {
    return await storeRepositoryInterface.getList(
        isStoreRecommendedItemList: true, storeId: storeId);
  }

  @override
  Future<CartSuggestItemModel?> getCartStoreSuggestedItemList(
      int? storeId,
      String languageCode,
      ModuleModel? module,
      int? cacheModuleId,
      int? moduleId) async {
    return await storeRepositoryInterface.getCartStoreSuggestedItemList(
        storeId, languageCode, module, cacheModuleId, moduleId);
  }

  @override
  Future<List<StoreBannerModel>?> getStoreBannerList(int? storeId) async {
    return await storeRepositoryInterface.getList(
        isStoreBannerList: true, storeId: storeId);
  }

  @override
  Future<List<Store>?> getRecommendedStoreList() async {
    return await storeRepositoryInterface.getList(isRecommendedStoreList: true);
  }

  @override
  List<Modules> moduleList() {
    List<Modules> moduleList = [];
    for (ZoneData zone
    in AddressHelper.getUserAddressFromSharedPref()!.zoneData ?? []) {
      for (Modules module in zone.modules ?? []) {
        moduleList.add(module);
      }
    }
    return moduleList;
  }

  @override
  String filterRestaurantLinkUrl(String slug, Store store) {
    List<String> routes = Get.currentRoute.split('?');
    String replace = '';

    if (AppConstants.useReactWebsite) {
      if (slug.isNotEmpty) {
        replace =
        '${routes[0]}/$slug?module_id=${store.moduleId}&module_type=${Get.find<SplashController>().module!.moduleType}&store_zone_id=${store.zoneId}&distance=${store.distance}';
      } else {
        replace =
        '${routes[0]}/${store.id}?module_id=${store.moduleId}&module_type=${Get.find<SplashController>().module!.moduleType}&store_zone_id=${store.zoneId}&distance=${store.distance}';
      }
    } else {
      if (slug.isNotEmpty) {
        replace = '${routes[0]}?slug=$slug';
      } else {
        replace = '${routes[0]}?slug=${store.id}';
      }
    }
    return replace;
  }
}
