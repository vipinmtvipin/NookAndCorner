import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';

class ReviewsListUseCase
    extends ParamUseCase<ReviewListResponds?, ReviewRequest> {
  final HomeRepository _repo;

  ReviewsListUseCase(this._repo);

  @override
  Future<ReviewListResponds?> execute(ReviewRequest params) {
    return _repo.reviewList(params);
  }
}
