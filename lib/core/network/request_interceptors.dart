import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/constants.dart';

class RequestHeaderInterceptor extends Interceptor {
  final sessionStorage = GetStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    getCustomHeaders(options).then((customHeaders) {
      options.headers.addAll(customHeaders);
      super.onRequest(options, handler);
    });
  }

  Future<Map<String, dynamic>> getCustomHeaders(RequestOptions options) async {
    var customHeaders = <String, dynamic>{};
    customHeaders['Content-Type'] = 'application/json';

    if (_needAuthorizationHeader(options)) {
      String token = sessionStorage.read(StorageKeys.token) ?? '';
      if (token.isNotNullOrEmpty) {
        customHeaders['Authorization'] =
            'Bearer ${sessionStorage.read(StorageKeys.token) ?? ''}';
      }
    }

    return customHeaders;
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.path == 'no_need_token') {
      return false;
    } else {
      return true;
    }
  }
}
