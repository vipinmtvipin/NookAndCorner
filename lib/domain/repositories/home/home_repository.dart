import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';

abstract class HomeRepository {
  Future<CityResponds?> getCity();
  Future<CityServiceResponds?> getCityServices(String cityId);
  Future<MidBannerResponds?> getMidBanner();
  Future<ActiveBannerResponds?> getActiveBanner();
}
