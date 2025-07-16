import '../models/advertisement_model.dart';
import '../repositories/advertisement_repository_interface.dart';
import 'advertisement_service_interface.dart';

class AdvertisementService implements AdvertisementServiceInterface{
  final AdvertisementRepositoryInterface advertisementRepositoryInterface;
  AdvertisementService({required this.advertisementRepositoryInterface});

  @override
  Future<List<AdvertisementModel>?> getAdvertisementList() async {
    return await advertisementRepositoryInterface.getList();
  }

}