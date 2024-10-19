import 'package:collection/collection.dart';
import 'package:customerapp/core/usecases/pram_usecase.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';
import 'package:customerapp/domain/repositories/service/service_repository.dart';
import 'package:tuple/tuple.dart';
import 'package:zip_future/zip_future.dart';

class SummeryUseCase extends ParamUseCase<
    Tuple2<MetaResponds, AddOnListResponds>, AddonRequest> {
  final ServiceRepository _repo;

  SummeryUseCase(this._repo);

  @override
  Future<Tuple2<MetaResponds, AddOnListResponds>> execute(
      AddonRequest request) async {
    final homeData = await ZipFuture.zip([
      _repo.getMetaData(),
      _repo.getAddOns(request),
    ]).executeThenMap<Tuple2<MetaResponds, AddOnListResponds>>(
      (results) {
        MetaResponds? metaData;
        AddOnListResponds? addonService;

        results.forEachIndexed((index, element) {
          switch (element) {
            case MetaResponds _:
              metaData = element;
              break;
            case AddOnListResponds _:
              addonService = element;
              break;
          }
        });

        return Tuple2(metaData!, addonService!);
      },
      onError: (index, error) {
        Logger.e('Error while fetching notification details:', '$error');
      },
    );

    return homeData;
  }
}
