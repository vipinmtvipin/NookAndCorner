import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/repositories/settings/settings_repository.dart';

class ReviewsUseCase extends ParamUseCase<ReviewListResponds?, ReviewRequest> {
  final SettingsRepository _repo;

  ReviewsUseCase(this._repo);

  @override
  Future<ReviewListResponds?> execute(ReviewRequest params) {
    return _repo.reviewList(params);
  }
}
