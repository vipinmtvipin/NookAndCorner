import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/repositories/settings/settings_repository.dart';

class ReviewsUseCase extends ParamUseCase<ReviewListResponds?, String> {
  final SettingsRepository _repo;

  ReviewsUseCase(this._repo);

  @override
  Future<ReviewListResponds?> execute(String params) {
    return _repo.reviewList(params);
  }
}
