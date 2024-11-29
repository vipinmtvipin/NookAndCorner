import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/repositories/my_job/myjob_repository.dart';

class AddCouponUseCase extends ParamUseCase<CuponResponds?, CouponRequest> {
  final MyJobRepository _repo;

  AddCouponUseCase(this._repo);

  @override
  Future<CuponResponds?> execute(CouponRequest params) {
    return _repo.applyCoupon(params);
  }
}
