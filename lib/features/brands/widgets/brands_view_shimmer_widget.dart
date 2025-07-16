import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/widgets/title_widget.dart';
import '../../../util/dimensions.dart';

class BrandViewShimmer extends StatelessWidget {
  const BrandViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault),
        child: TitleWidget(
          title: 'brands'.tr,
          onTap: () => null,
        ),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
          childAspectRatio: 1.0,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).disabledColor.withOpacity(0.1),
            highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
            ),
          );

        },
      ),
    ]);
  }
}
