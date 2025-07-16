import '../../../../common/models/response_model.dart';
import '../models/address_model.dart';
import '../repositories/address_repository_interface.dart';
import 'address_service_interface.dart';

class AddressService implements AddressServiceInterface{
  final AddressRepositoryInterface addressRepoInterface;
  AddressService({required this.addressRepoInterface});

  @override
  Future<List<AddressModel>?> getAllAddress() async {
    return await addressRepoInterface.getList();
  }

  @override
  Future<ResponseModel> removeAddressByID(int? id) async {
    return await addressRepoInterface.delete(id);
  }

  @override
  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    return await addressRepoInterface.add(addressModel);
  }

  @override
  Future<ResponseModel> updateAddress(AddressModel addressModel, int? addressId) async {
    return await addressRepoInterface.update(addressModel.toJson(), addressId);
  }

}