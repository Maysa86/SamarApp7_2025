import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../store/controllers/store_controller.dart';
import '../../../../common/widgets/custom_loader.dart';
import '../nearbybigstoreswidget.dart';

class NearbyStoreView extends StatelessWidget {
  const NearbyStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      final nearbyStores = storeController.nearbyStoreList
          ?.where((store) => store.featured == 0)
          .toList();

      if (nearbyStores == null) {
        return const CustomLoaderWidget();
      }

      if (nearbyStores.isEmpty) {
        return const SizedBox(); // أو عرض رسالة: لا توجد متاجر قريبة
      }

      return NearbyBigStoresWidget(stores: nearbyStores);
    });
  }
}
