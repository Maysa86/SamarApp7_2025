import '../models/basic_campaign_model.dart';
import '../models/item_model.dart';
import '../repositories/campaign_repository_interface.dart';
import 'campaign_service_interface.dart';

class CampaignService implements CampaignServiceInterface {
  final CampaignRepositoryInterface campaignRepositoryInterface;
  CampaignService({required this.campaignRepositoryInterface});

  @override
  Future<List<BasicCampaignModel>?> getBasicCampaignList() async {
    return await campaignRepositoryInterface.getList(isBasicCampaign: true);
  }

  @override
  Future<BasicCampaignModel?> getCampaignDetails(String campaignID) async {
    return await campaignRepositoryInterface.get(campaignID);
  }

  @override
  Future<List<Item>?> getItemCampaignList() async {
    return await campaignRepositoryInterface.getList(isItemCampaign: true);
  }

}