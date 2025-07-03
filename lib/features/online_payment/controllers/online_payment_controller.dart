import 'package:get/get.dart';
import '../domain/services/online_payment_service_interface.dart';

class OnlinePaymentController extends GetxController implements GetxService {
  final OnlinePaymentServiceInterface onlinePaymentServiceInterface;

  OnlinePaymentController({required this.onlinePaymentServiceInterface});
}