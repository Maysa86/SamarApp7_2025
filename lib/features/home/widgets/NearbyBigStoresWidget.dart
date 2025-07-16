import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_image.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../store/domain/models/store_model.dart';
import '../../../helper/route_helper.dart';

class NearbyBigStoresWidget extends StatelessWidget {
  final List<Store> stores;

  const NearbyBigStoresWidget({
    super.key,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام قائمة المتاجر القادمة من الـ constructor وتصفيتها حسب featured == 0
    final List<Store> filteredStores = stores
        .where((store) => store.featured == 0)
        .toList();

    // تجميع المتاجر في أزواج (كل صف يحتوي على 2)
    final List<List<Store>> groupedStores = [];
    for (int i = 0; i < filteredStores.length; i += 2) {
      groupedStores.add(
        filteredStores.sublist(
          i,
          i + 2 > filteredStores.length ? filteredStores.length : i + 2,
        ),
      );
    }

    if (filteredStores.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall,
          ),
          child: Text(
            'Big_Brands_Near_You'.tr,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: groupedStores.length,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              final pair = groupedStores[index];
              return Column(
                children: pair.map((store) {
                  return InkWell(
                    onTap: () => Get.toNamed(
                      RouteHelper.getStoreRoute(id: store.id!, page: 'store'),
                    ),
                    child: Container(
                      width: 300,
                      height: 75,
                      margin: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeSmall,
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImage(
                              image: (store.logoFullUrl != null && store.logoFullUrl!.trim().isNotEmpty)
                                  ? store.logoFullUrl!
                                  : 'https://via.placeholder.com/60x75.png?text=No+Logo',

                              height: 75,
                              width: 60,
                              fit: BoxFit.cover,
                            )

                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  store.name!,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${store.deliveryTime}',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
