import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class NewTag extends StatelessWidget {
  final double? top;
  const NewTag({super.key, this.top = 5});

  @override
  Widget build(BuildContext context) {
    bool isLtr = Get.locale?.languageCode != 'ar';

    return Positioned(
      top: top,
      left: isLtr ? 10 : null,
      right: isLtr ? null : 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          'new'.tr,
          style: robotoMedium.copyWith(
            color: Theme.of(context).cardColor,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
      ),
    );
  }
}
