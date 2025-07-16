import 'package:image_picker/image_picker.dart';
import '../models/userinfo_model.dart';
import '../../../../interfaces/repository_interface.dart';

abstract class ProfileRepositoryInterface extends RepositoryInterface {
  Future<dynamic> updateProfile(UserInfoModel userInfoModel, XFile? data, String token);
  Future<dynamic> changePassword(UserInfoModel userInfoModel);
}