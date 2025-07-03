import 'package:get/get.dart';

import '../common/widgets/custom_snackbar.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/favourite/controllers/favourite_controller.dart';
import '../helper/route_helper.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) {
    if (response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData().then((value) {
        Get.find<FavouriteController>().removeFavourite();
        Get.offAllNamed(RouteHelper.getInitialRoute());
      });
    } else {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
    }
  }
}
