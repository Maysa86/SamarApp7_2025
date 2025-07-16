import '../../../item/domain/models/item_model.dart';
import '../../../../interfaces/repository_interface.dart';

abstract class BrandsRepositoryInterface extends RepositoryInterface {
  Future<ItemModel?> getBrandItemList({required int brandId, int? offset});
}