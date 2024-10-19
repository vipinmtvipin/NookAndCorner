import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';

class ApplyCouponUseCase extends ParamUseCase<CuponResponds?, CouponRequest> {
  final ServiceRepository _repo;

  ApplyCouponUseCase(this._repo);

  @override
  Future<CuponResponds?> execute(CouponRequest params) {
    return _repo.applyCoupon(params);
  }
}
