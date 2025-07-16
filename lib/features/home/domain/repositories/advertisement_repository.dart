import 'package:get/get.dart';
import '../../../../api/api_client.dart';
import '../models/advertisement_model.dart';
import 'advertisement_repository_interface.dart';
import '../../../../util/app_constants.dart';

class AdvertisementRepository implements AdvertisementRepositoryInterface {
  final ApiClient apiClient;
  AdvertisementRepository({required this.apiClient});

  @override
  Future<List<AdvertisementModel>?> getList({int? offset}) async {
    List<AdvertisementModel>? advertisementList;
    Response response = await apiClient.getData(AppConstants.advertisementListUri);
    if(response.statusCode == 200) {
      advertisementList = [];
      response.body.forEach((data) {
        advertisementList?.add(AdvertisementModel.fromJson(data));
      });
    }
    return advertisementList;
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