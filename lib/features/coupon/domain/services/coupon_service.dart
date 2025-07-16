import '../models/coupon_model.dart';
import '../repositories/coupon_repository_interface.dart';
import 'coupon_service_interface.dart';

class CouponService implements CouponServiceInterface{
  final CouponRepositoryInterface couponRepositoryInterface;
  CouponService({required this.couponRepositoryInterface});

  @override
  Future<List<CouponModel>?> getCouponList() async {
    return await couponRepositoryInterface.getList(couponList: true);
  }

  @override
  Future<List<CouponModel>?> getTaxiCouponList() async {
    return await couponRepositoryInterface.getList(taxiCouponList: true);
  }

  @override
  Future<CouponModel?> applyCoupon(String couponCode, int? storeID) async {
    return await couponRepositoryInterface.applyCoupon(couponCode, storeID);
  }

  @override
  Future<CouponModel?> applyTaxiCoupon(String couponCode, int? providerId) async {
    return await couponRepositoryInterface.applyTaxiCoupon(couponCode, providerId);
  }

}