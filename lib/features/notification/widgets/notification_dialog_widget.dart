import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';

import '../../../helper/route_helper.dart';
import '../domain/models/notification_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../../common/widgets/custom_image.dart';
import 'package:flutter/material.dart';

class NotificationDialogWidget extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationDialogWidget({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall))),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              (notificationModel.imageFullUrl != null &&
                      notificationModel.imageFullUrl!.isNotEmpty)
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeLarge),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.20)),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          isNotification: true,
                          image: '${notificationModel.imageFullUrl}',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                  height: (notificationModel.imageFullUrl != null &&
                          notificationModel.imageFullUrl!.isNotEmpty)
                      ? Dimensions.paddingSizeLarge
                      : 0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  notificationModel.data?.title ?? '',
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Text(
                  notificationModel.data?.description ?? '',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
              if ((notificationModel.data!.description ?? '').contains('id'))
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomButton(
                    buttonText: 'Go to Order',
                    onPressed: () {
                      Get.back();
                      Get.toNamed(
                        RouteHelper.getOrderDetailsRoute(
                          int.tryParse(notificationModel.data!.description!
                              .split(':')
                              .last),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
