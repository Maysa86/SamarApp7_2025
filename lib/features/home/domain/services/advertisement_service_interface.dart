import '../models/advertisement_model.dart';

abstract class AdvertisementServiceInterface {
  Future<List<AdvertisementModel>?> getAdvertisementList();
}