import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/constants.dart';

const String apiKEY = "";

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
      //* Request methods PUT, POST, PATCH, DELETE needs access token,
      // * which needs to be passed with "Authorization" header as Bearer token.
      customHeaders['Authorization'] =
          'Bearer ${sessionStorage.read(StorageKeys.token)}';
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
