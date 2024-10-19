import 'package:customerapp/domain/model/login/login_responds.dart';
import 'package:dio/dio.dart';

class DioExceptionData implements Exception {
  late String errorMessage;

  DioExceptionData.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorMessage = 'Request to the server was cancelled.';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timed out.';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receiving timeout occurred.';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Request send timeout.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(dioError.response);
        break;
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          errorMessage = 'No Internet.';
          break;
        }
        errorMessage = 'Unexpected error occurred.';
        break;
      default:
        _handleStatusCode(dioError.response);
        break;
    }
  }

  String _handleStatusCode(Response<dynamic>? response) {
    if (response == null) {
      return 'Something went wrong';
    }
    final LoginResponds data = loginRespondsFromJson(response.toString());

    switch (data.statusCode) {
      case 400:
        return 'Bad request - Invalid data';
      case 401:
        return data.message ?? 'Unauthorized User';
      case 403:
        return 'The authenticated user is not allowed to access the specified API endpoint.';
      case 404:
        return 'The requested resource does not exist.';
      case 405:
        return 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
      case 409:
        return data.message ?? 'Conflict';
      case 415:
        return 'Unsupported media type. The requested content type or version number is invalid.';
      case 422:
        return 'Data validation failed.';
      case 429:
        return 'Too many requests.';
      case 500:
        return 'Internal server error.';
      default:
        return data.message ?? 'Oops something went wrong!';
    }
  }

  @override
  String toString() => errorMessage;
}
