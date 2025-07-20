import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart' as fc;
import 'dart:io';
import '../features/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    return result != ConnectivityResult.none;
  }


  static void checkConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

      if (Get.find<SplashController>().firstTimeConnectionCheck) {
        Get.find<SplashController>().setFirstTimeConnectionCheck(false);
      } else {
        bool isNotConnected = result == ConnectivityResult.none;

        if (!isNotConnected) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
      }
    });
  }


  static Future<XFile> compressImage(XFile file) async {
    final targetPath = '${file.path}_compressed.jpg';

    final result = await fc.FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 60, // غيري القيمة حسب الحجم المطلوب
      format: fc.CompressFormat.jpeg,
    );

    if (kDebugMode) {
      final inputSize = await File(file.path).length();
      final outputSize = result != null ? await result.length() : 0;
      log('Input size : ${inputSize / 1048576}');
      log('Output size : ${outputSize / 1048576}');
    }

    return result != null ? XFile(result.path) : file;
  }

}
