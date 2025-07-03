import 'package:get/get.dart';

import '../../../../common/models/module_model.dart';
import '../../../../common/models/response_model.dart';
import '../models/landing_model.dart';

abstract class SplashServiceInterface {
  Future<Response> getConfigData();
  Future<LandingModel?> getLandingPageData();
  Future<ModuleModel?> initSharedData();
  void disableIntro();
  bool? showIntro();
  Future<void> setStoreCategory(int storeCategoryID);
  Future<List<ModuleModel>?> getModules({Map<String, String>? headers});
  Future<void> setModule(ModuleModel? module);
  Future<void> setCacheModule(ModuleModel? module);
  ModuleModel? getCacheModule();
  ModuleModel? getModule();
  Future<ResponseModel> subscribeEmail(String email);
  bool getSavedCookiesData();
  Future<void> saveCookiesData(bool data);
  void cookiesStatusChange(String? data);
  bool getAcceptCookiesStatus(String data);
  bool getSuggestedLocationStatus();
  Future<void> saveSuggestedLocationStatus(bool data);
  bool getReferBottomSheetStatus();
  Future<void> saveReferBottomSheetStatus(bool data);
}
