import '../models/banner_model.dart';
import '../models/others_banner_model.dart';
import '../models/promotional_banner_model.dart';

abstract class BannerServiceInterface {
  Future<BannerModel?> getBannerList();
  Future<BannerModel?> getTaxiBannerList();
  Future<BannerModel?> getFeaturedBannerList();
  Future<ParcelOtherBannerModel?> getParcelOtherBannerList();
  Future<PromotionalBanner?> getPromotionalBannerList();
  List<int?> moduleIdList();
}
