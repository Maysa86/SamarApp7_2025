import '../../../cart/domain/models/cart_model.dart';
import '../models/basic_medicine_model.dart';
import '../models/common_condition_model.dart';
import '../models/item_model.dart';

abstract class ItemServiceInterface {
  Future<List<Item>?> getPopularItemList(String type, {int? moduleId , int limit = 20,
    int offset = 1, });
  Future<ItemModel?> getReviewedItemList(String type);
  Future<ItemModel?> getFeaturedCategoriesItemList();
  Future<List<Item>?> getRecommendedItemList(String type, {int? moduleId});
  Future<List<Item>?> getDiscountedItemList(String type);
  Future<Item?> getItemDetails(int? itemID);
  Future<BasicMedicineModel?> getBasicMedicine();
  Future<List<CommonConditionModel>?> getCommonConditions();
  Future<List<Item>?> getConditionsWiseItems(int id);
  List<bool> initializeCartAddonActiveList(
      List<AddOn>? addOnIds, List<AddOns>? addOns);
  List<int?> initializeCartAddonsQtyList(
      List<AddOn>? addOnIds, List<AddOns>? addOns);
  List<bool> collapseVariation(List<FoodVariation>? foodVariations);
  List<int> initializeCartVariationIndexes(
      List<Variation>? variation, List<ChoiceOptions>? choiceOptions);
  List<List<bool?>> initializeSelectedVariation(
      List<FoodVariation>? foodVariations);
  List<bool> initializeCollapseVariation(List<FoodVariation>? foodVariations);
  List<int> initializeVariationIndexes(List<ChoiceOptions>? choiceOptions);
  List<bool> initializeAddonActiveList(List<AddOns>? addOns);
  List<int> initializeAddonQtyList(List<AddOns>? addOns);
  Future<String> prepareVariationType(
      List<ChoiceOptions>? choiceOptions, List<int>? variationIndex);
  int setAddOnQuantity(bool isIncrement, int addOnQty);
  int setQuantity(bool isIncrement, bool moduleStock, int? stock, int qty,
      int? quantityLimit,
      {bool getxSnackBar = false});
  List<List<bool?>> setNewCartVariationIndex(
      int index,
      int i,
      List<FoodVariation>? foodVariations,
      List<List<bool?>> selectedVariations);
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index);
  double? getStartingPrice(Item item);
  Future<int> isExistInCartForBottomSheet(List<CartModel> cartList, int? itemId,
      int? cartIndex, List<List<bool?>>? variations);
}
