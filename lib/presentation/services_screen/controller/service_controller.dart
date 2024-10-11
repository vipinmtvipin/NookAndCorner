import 'package:customerapp/presentation/base_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum HomeStatus {
  unknown,
  loaded,
  initiated,
  dateDataLoaded,
}

class ServiceController extends BaseController {
  Rx<DateTime> selectedDate = Rx(DateTime.now());
  // Rx<String> selectedDateValue = Rx('Select Date');
  var selectedDateValue = 'Select Date'.obs;

  var homeStatus = HomeStatus.unknown.obs;

  void dateSelected(DateTime date) {
    selectedDate.value = date;
    selectedDateValue.value = DateFormat('dd/MM/yyyy').format(date);

    homeStatus.value = HomeStatus.dateDataLoaded;
  }
}
