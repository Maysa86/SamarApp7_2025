import '../../../category/controllers/category_controller.dart';
import '../../../language/controllers/language_controller.dart';
import '../../../splash/controllers/splash_controller.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../../common/widgets/custom_image.dart';
import '../category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<SplashController>(builder: (splashController) {
      bool isPharmacy = splashController.module != null && splashController.module!.moduleType.toString() == AppConstants.pharmacy;
      bool isFood = splashController.module != null && splashController.module!.moduleType.toString() == AppConstants.food;

      return GetBuilder<CategoryController>(builder: (categoryController) {
        return (categoryController.categoryList != null && categoryController.categoryList!.isEmpty)
        ? const SizedBox() : isPharmacy ? PharmacyCategoryView(categoryController: categoryController)
          : isFood ? FoodCategoryView(categoryController: categoryController) : Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 230,
                    child: categoryController.categoryList != null ? GridView.builder(
                      scrollDirection: Axis.horizontal, // السحب الجانبي
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // صفين
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1, // تناسب العرض والطول
                      ),
                      itemCount: categoryController.categoryList!.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.categoryList![index];
                        return InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.getCategoryItemRoute(category.id, category.name!));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomImage(
                                  image: '${category.imageFullUrl}',
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text(
                                category.name!,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 1, // تحديد عدد الأسطر
                                overflow: TextOverflow.ellipsis, // منع النص من الخروج
                              ),
                            ],
                          ),
                        );
                      },
                    )

                        : CategoryShimmer(categoryController: categoryController),
                  ),
                ),

                ResponsiveHelper.isMobile(context) ? const SizedBox() : categoryController.categoryList != null ? Column(
                  children: [
                    InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (con) => Dialog(child: SizedBox(height: 550, width: 600, child: CategoryPopUp(
                          categoryController: categoryController,
                        ))));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text('view_all'.tr, style: TextStyle(fontSize: Dimensions.paddingSizeDefault, color: Theme.of(context).cardColor)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,)
                  ],
                ): CategoryShimmer(categoryController: categoryController),
              ],
            ),

          ],
        );
      });
    }
    );
  }
}

class PharmacyCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 160,
        child: categoryController.categoryList != null ? ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
          itemCount: categoryController.categoryList!.length > 10 ? 10 : categoryController.categoryList!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
              child: InkWell(
                onTap: () {
                  if(index == 9 && categoryController.categoryList!.length > 10) {
                    Get.toNamed(RouteHelper.getCategoryRoute());
                  } else {
                    Get.toNamed(RouteHelper.getCategoryItemRoute(
                      categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                    ));
                  }
                },
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.3),
                        Theme.of(context).cardColor.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Column(children: [

                    Stack(
                      children: [

                        ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                          child: CustomImage(
                            image: '${categoryController.categoryList![index].imageFullUrl}',
                            height: 60, width: double.infinity, fit: BoxFit.cover,
                          ),
                        ),

                        (index == 9 && categoryController.categoryList!.length > 10) ? Positioned(
                          right: 0, left: 0, top: 0, bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).primaryColor.withOpacity(0.4),
                                  Theme.of(context).primaryColor.withOpacity(0.6),
                                  Theme.of(context).primaryColor.withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+${categoryController.categoryList!.length - 10}',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                                maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                              ),
                            )
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Expanded(child: Text(
                      (index == 9 && categoryController.categoryList!.length > 10) ? 'see_all'.tr :  categoryController.categoryList![index].name!,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,
                      color: (index == 9 && categoryController.categoryList!.length > 10) ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color),
                      maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                    )),
                  ]),
                ),
              ),
            );
          },
        ) : PharmacyCategoryShimmer(categoryController: categoryController),
      ),
    ]);
  }
}

class FoodCategoryView extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryView({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Stack(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 230,
          child: categoryController.categoryList != null ? GridView.builder(
            scrollDirection: Axis.horizontal, // السحب الجانبي
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // صفين
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1, // تناسب العرض والطول
            ),
            itemCount: categoryController.categoryList!.length,
            itemBuilder: (context, index) {
              final category = categoryController.categoryList![index];
              return InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getCategoryItemRoute(category.id, category.name!));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CustomImage(
                        image: '${category.imageFullUrl}',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      category.name!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      maxLines: 1, // تحديد عدد الأسطر
                      overflow: TextOverflow.ellipsis, // منع النص من الخروج
                    ),
                  ],
                ),
              );
            },
          )

              : FoodCategoryShimmer(categoryController: categoryController),
        ),
      ]),

    ]);
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const CategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: Dimensions.paddingSizeDefault),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 155,
              width: 250,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        const Expanded(flex: 3, child: SizedBox()),
                        Expanded(
                          flex: 4,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Container(
                                      height: 10,
                                      width: 50,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ]),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 15,
                                          color: Theme.of(context).primaryColor),
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                      Container(
                                        height: 10,
                                        width: 50,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(Icons.favorite_border,
                                  color: Theme.of(context).disabledColor,
                                  size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 10,
                      width: 100,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

        );
      },
    );
  }
}

class FoodCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const FoodCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: SizedBox(
              width: 60,
              child: Column(children: [

                Container(
                  height: 60, width: double.infinity,
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Container(
                    height: 10, width: 50,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
          ),

        );
      },
    );
  }
}

class PharmacyCategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  const PharmacyCategoryShimmer({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
              child: Column(children: [

                Container(
                  height: 60, width: double.infinity,
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Container(
                    height: 10, width: 50,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
          ),

        );
      },
    );
  }
}