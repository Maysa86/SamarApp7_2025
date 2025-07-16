import '../../../../common/models/response_model.dart';
import '../models/review_body_model.dart';
import '../models/review_model.dart';
import '../repositories/review_repository_interface.dart';
import 'review_service_interface.dart';

class ReviewService implements ReviewServiceInterface {
  final ReviewRepositoryInterface reviewRepositoryInterface;
  ReviewService({required this.reviewRepositoryInterface});

  @override
  Future<List<ReviewModel>?> getStoreReviewList(String? storeID) async {
    return await reviewRepositoryInterface.getList(storeID: storeID);
  }


  @override
  Future<ResponseModel> submitReview(ReviewBodyModel reviewBody) async {
    return await reviewRepositoryInterface.submitReview(reviewBody);
  }

  @override
  Future<ResponseModel> submitDeliveryManReview(ReviewBodyModel reviewBody) async {
    return await reviewRepositoryInterface.submitDeliveryManReview(reviewBody);
  }


}