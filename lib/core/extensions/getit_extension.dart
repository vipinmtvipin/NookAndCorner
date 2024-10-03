import 'package:get_it/get_it.dart';
import 'package:customerapp/core/utils/logger.dart';

extension GetItExtension on GetIt {
  T? getOrNull<T extends Object>() {
    try {
      return GetIt.I.get<T>();
    } on StateError catch (error) {
      Logger.e("GetItExtension", error.toString());
      return null;
    }
  }
}
