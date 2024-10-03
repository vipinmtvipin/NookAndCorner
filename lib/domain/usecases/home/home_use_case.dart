import 'package:collection/collection.dart';
import 'package:customerapp/core/usecases/no_param_usecase.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';
import 'package:customerapp/domain/repositories/home/home_repository.dart';
import 'package:tuple/tuple.dart';
import 'package:zip_future/zip_future.dart';

class HomeUseCase extends NoParamUseCase<
    Tuple3<List<CityResponds>, List<ActiveBannerResponds>,
        List<MidBannerResponds>>> {
  final HomeRepository _repo;
  HomeUseCase(this._repo);

  @override
  Future<
      Tuple3<List<CityResponds>, List<ActiveBannerResponds>,
          List<MidBannerResponds>>> execute() async {
    final homeData = await ZipFuture.zip([
      _repo.getCity(),
      _repo.getActiveBanner(),
      _repo.getMidBanner(),
    ]).executeThenMap<
        Tuple3<List<CityResponds>, List<ActiveBannerResponds>,
            List<MidBannerResponds>>>(
      (results) {
        List<CityResponds>? citys = [];
        List<ActiveBannerResponds> banners = [];
        List<MidBannerResponds> midBanners = [];

        results.forEachIndexed((index, element) {
          switch (element) {
            case List<CityResponds> _:
              citys = element;
              break;
            case List<ActiveBannerResponds> _:
              banners = element;
              break;
            case List<MidBannerResponds> _:
              midBanners = element;
              break;
          }
        });

        return Tuple3(citys!, banners, midBanners);
      },
      onError: (index, error) {
        Logger.e('Error while fetching notification details:', '$error');
      },
    );

    return homeData;
  }
}
