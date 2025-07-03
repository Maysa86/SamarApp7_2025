import '../models/flash_sale_model.dart';
import '../models/product_flash_sale.dart';
import '../repositories/flash_sale_repository_interface.dart';
import 'flash_sale_service_interface.dart';

class FlashSaleService implements FlashSaleServiceInterface{
  final FlashSaleRepositoryInterface flashSaleRepositoryInterface;
  FlashSaleService({required this.flashSaleRepositoryInterface});

  @override
  Future<FlashSaleModel?> getFlashSale() async {
    return await flashSaleRepositoryInterface.getFlashSale();
  }

  @override
  Future<ProductFlashSale?> getFlashSaleWithId(int id, int offset) async {
    return await flashSaleRepositoryInterface.getFlashSaleWithId(id, offset);
  }

}