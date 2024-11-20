import 'package:customerapp/domain/model/common_responds.dart';
import 'package:customerapp/domain/model/settings/address_request.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';

abstract class SettingsRepository {
  Future<CommonResponds?> contactUs(ContactRequest request);
  Future<ReviewListResponds?> reviewList(ReviewRequest request);
}
