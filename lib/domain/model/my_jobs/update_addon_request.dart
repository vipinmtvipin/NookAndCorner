import 'package:customerapp/domain/model/summery/addon_service_responds.dart';

class UpdateAddonRequest {
  List<AddOnData> addons;
  String? convenienceFee;
  String? grandTotal;
  String? serviceId;

  String? jobId;

  UpdateAddonRequest({
    this.addons = const [],
    this.convenienceFee,
    this.grandTotal,
    this.serviceId,
    this.jobId,
  });

  toJson() {
    return {
      'addons': addons.map((e) => e.toJson()).toList(),
      'convenienceFee': convenienceFee,
      'grandTotal': grandTotal,
      'serviceId': serviceId,
    };
  }
}
