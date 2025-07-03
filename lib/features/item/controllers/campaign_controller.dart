import '../../splash/controllers/splash_controller.dart';
import '../domain/models/basic_campaign_model.dart';
import '../domain/models/item_model.dart';
import 'package:get/get.dart';
import '../domain/services/campaign_service_interface.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignServiceInterface campaignServiceInterface;
  CampaignController({required this.campaignServiceInterface});

  List<BasicCampaignModel>? _basicCampaignList;
  List<BasicCampaignModel>? get basicCampaignList => _basicCampaignList;

  BasicCampaignModel? _basicCampaign;
  BasicCampaignModel? get basicCampaign => _basicCampaign;

  List<Item>? _itemCampaignList;
  List<Item>? get itemCampaignList => _itemCampaignList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void itemCampaignNull(){
    _itemCampaignList = null;
  }

  Future<void> getBasicCampaignList(bool reload) async {
    if(_basicCampaignList == null || reload) {
      List<BasicCampaignModel>? basicCampaignList = await campaignServiceInterface.getBasicCampaignList();
      if (basicCampaignList != null) {
        _basicCampaignList = [];
        _basicCampaignList!.addAll(basicCampaignList);
      }
      update();
    }
  }

  Future<void> getBasicCampaignDetails(int? campaignID) async {
    _basicCampaign = null;
    BasicCampaignModel? basicCampaign = await campaignServiceInterface.getCampaignDetails(campaignID.toString());
    if (basicCampaign != null) {
      _basicCampaign = basicCampaign;
    }
    update();
  }

  Future<void> getItemCampaignList(bool reload) async {
    if(_itemCampaignList == null || reload) {
      List<Item>? itemCampaignList = await campaignServiceInterface.getItemCampaignList();
      if (itemCampaignList != null) {
        _itemCampaignList = [];
        List<Item> campaign = [];
        campaign.addAll(itemCampaignList);
        for (var c in campaign) {
          if(!Get.find<SplashController>().getModuleConfig(c.moduleType).newVariation! || c.variations!.isEmpty || c.foodVariations!.isNotEmpty) {
            _itemCampaignList!.add(c);
          }
        }
      }
      update();
    }
  }
  void clearCampaigns() {
    _basicCampaignList = null;
    _itemCampaignList = null;
    _basicCampaign = null;
    update();
  }

}