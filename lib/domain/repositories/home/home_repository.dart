import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';
import 'package:customerapp/domain/model/home/push_request.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';

abstract class HomeRepository {
  Future<CityResponds?> getCity();
  Future<CityServiceResponds?> getCityServices(String cityId);
  Future<MidBannerResponds?> getMidBanner();
  Future<ActiveBannerResponds?> getActiveBanner();
  Future<ReviewListResponds?> reviewList(ReviewRequest request);
  Future<CommonResponds?> updatePushToken(PushRequest pushRequest);
}
