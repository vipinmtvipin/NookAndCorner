import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';

abstract class ServiceRepository {
  Future<ServiceDetailsResponds?> getServiceDetails(String categoryId);
  Future<TagResponds?> getServiceTags(String categoryId);
  Future<ServiceDetailsResponds?> getServiceByTag(
      TimeSlotRequest timeSlotRequest);
  Future<TimeSlotResponds?> getTimeSlotes(TimeSlotRequest request);
}
