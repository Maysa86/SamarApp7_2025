import 'package:get/get_connect.dart';
import 'package:image_picker/image_picker.dart';
import '../models/store_body_model.dart';
import '../../../../interfaces/repository_interface.dart';

abstract class StoreRegistrationRepositoryInterface extends RepositoryInterface{
  Future<Response> registerStore(StoreBodyModel store, XFile? logo, XFile? cover);
  Future<bool> checkInZone(String? lat, String? lng, int zoneId);
}