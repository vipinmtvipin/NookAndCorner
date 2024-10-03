import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';

abstract class HomeRepository {
  Future<List<CityResponds>?> getCity();
  Future<List<CityServiceResponds>?> getCityServices(String cityId);
  Future<List<MidBannerResponds>?> getMidBanner();
  Future<List<ActiveBannerResponds>?> getActiveBanner();
}
