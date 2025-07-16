import '../models/brands_model.dart';
import '../repositories/brands_repository_interface.dart';
import 'brands_service_interface.dart';
import '../../../item/domain/models/item_model.dart';

class BrandsService implements BrandsServiceInterface {
  final BrandsRepositoryInterface brandsRepositoryInterface;
  BrandsService({required this.brandsRepositoryInterface});

  @override
  Future<List<BrandModel>?> getBrandList() async {
    return await brandsRepositoryInterface.getList();
  }

  @override
  Future<ItemModel?> getBrandItemList({required int brandId, int? offset}) async {
    return await brandsRepositoryInterface.getBrandItemList(brandId: brandId, offset: offset);
  }

}