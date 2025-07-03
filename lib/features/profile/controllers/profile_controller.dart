import 'dart:typed_data';
import '../../favourite/controllers/favourite_controller.dart';
import '../../chat/domain/models/conversation_model.dart';
import '../../../common/models/response_model.dart';
import '../domain/models/userinfo_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../helper/network_info.dart';
import '../../../helper/route_helper.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../domain/services/profile_service_interface.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileServiceInterface profileServiceInterface;
  ProfileController({required this.profileServiceInterface});

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel => _userInfoModel;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  Uint8List? _rawFile;
  Uint8List? get rawFile => _rawFile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getUserInfo() async {
    _pickedFile = null;
    _rawFile = null;
    UserInfoModel? userInfoModel = await profileServiceInterface.getUserInfo();
    if (userInfoModel != null) {
      _userInfoModel = userInfoModel;
    }
    update();
  }

  void setForceFullyUserEmpty() {
    _userInfoModel = null;
  }

  Future<ResponseModel> updateUserInfo(
      UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.updateProfile(
        updateUserModel, _pickedFile, token);
    _isLoading = false;

    return responseModel;
  }

  Future<ResponseModel> changePassword(UserInfoModel updatedUserModel) async {
    _isLoading = true;
    update();
    ResponseModel responseModel =
        await profileServiceInterface.changePassword(updatedUserModel);

    return responseModel;
  }

  void updateUserWithNewData(User? user) {
    _userInfoModel!.userInfo = user;
  }

  void pickImage() async {}

  void initData({bool isUpdate = false}) {
    _pickedFile = null;
    _rawFile = null;
    if (isUpdate) {
      update();
    }
  }

  Future deleteUser() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await profileServiceInterface.deleteUser();
    _isLoading = false;
    if (responseModel.isSuccess) {
    } else {}
  }

  void clearUserInfo() {
    _userInfoModel = null;
    update();
  }
}
