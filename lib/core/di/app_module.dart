import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:customerapp/core/network/api_service.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/utils/common_util.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppModule {
  Future<void> init() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /** init the local session storage**/
    await GetStorage.init();

    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

    GetIt.I.registerSingleton<Connectivity>(Connectivity());
    GetIt.I.registerSingleton<ConnectivityService>(ConnectivityService());

    final packageInfo = await PackageInfo.fromPlatform();
    GetIt.I.registerSingleton<PackageInfo>(packageInfo);

    GetIt.I.registerSingleton<ApiService>(ApiService());
    GetIt.I.registerSingleton<CommonUtil>(CommonUtil());
  }
}
