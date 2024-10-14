import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/usecases/service/service_by_tag_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_details_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_slots_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_tags_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

enum ServiceStatus {
  unknown,
  loaded,
  initiated,
  dateDataLoaded,
}

class ServiceController extends BaseController {
  final ServiceDetailsByTagUseCase _serviceDetailsByTagUseCase;
  final ServiceDetailsUseCase _serviceDetailsUseCase;
  final ServiceTagsUseCase _serviceTagUseCase;
  final ServiceSlotsUseCase _serviceSlotsUseCase;
  ServiceController(
      this._serviceDetailsByTagUseCase,
      this._serviceDetailsUseCase,
      this._serviceTagUseCase,
      this._serviceSlotsUseCase);

  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<ServiceData>> serviceInfo = Rx([]);
  Rx<List<TimeSlotData>> timeSlots = Rx([]);
  Rx<List<TagData>> tagData = Rx([]);

  Rx<ServiceData> selectedService = Rx(ServiceData.empty());

  Rx<DateTime> selectedDate = Rx(DateTime.now());
  // Rx<String> selectedDateValue = Rx('Select Date');
  var selectedDateValue = 'Select Date'.obs;
  var selectedTime = ''.obs;

  var serviceStatus = ServiceStatus.unknown.obs;

  var couponApplied = false.obs;
  var termsAndConditionApply = false.obs;
  var categoryId = "".obs;
  var categoryName = "".obs;
  var categoryDescription = "".obs;

  final sessionStorage = GetStorage();

  var isLogin = false;

  @override
  void onInit() {
    super.onInit();

    isLogin = sessionStorage.read(StorageKeys.loggedIn) ?? false;

    final arguments = Get.arguments as Map<String, dynamic>;

    categoryId.value = arguments['categoryId'] ?? '';
    categoryName.value = arguments['categoryName'] ?? '';
    categoryDescription.value = arguments['categoryDescription'] ?? '';

    getServiceDetails(categoryId.toString());
    getServiceTags(categoryId.toString());
  }

  Future<void> getServiceDetails(String categoryId,
      {bool fromTag = false}) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var services = await _serviceDetailsUseCase.execute(categoryId);
        serviceInfo.value = services?.data ?? [];

        serviceStatus.value = ServiceStatus.loaded;

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> getServiceByTagClick(String tagId) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var updatedTagData = tagData.value.map((element) {
          if (element.catTagId.toString() == tagId ||
              element.categoryTag == tagId) {
            return element.copyWith(isSelected: true);
          } else {
            return element.copyWith(isSelected: false);
          }
        }).toList();

        tagData.value = updatedTagData;
        serviceInfo.value = [];
        timeSlots.value = [];

        ServiceDetailsResponds services;
        if (tagId == 'All') {
          getServiceDetails(categoryId.value);
        } else {
          TimeSlotRequest request = TimeSlotRequest(
            categoryId: categoryId.value,
            tagId: tagId,
          );
          var services = await _serviceDetailsByTagUseCase.execute(request);
          serviceInfo.value = services?.data ?? [];
        }
        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> getServiceTags(String categoryId) async {
    if (await _connectivityService.isConnected()) {
      try {
        var services = await _serviceTagUseCase.execute(categoryId);
        tagData.value = services?.data ?? [];

        var element = TagData(
          catTagId: 0,
          status: 'all',
          deleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSelected: true,
          categoryTag: 'All',
        );
        tagData.value.insert(0, element);
      } catch (e) {
        e.printInfo();
      }
    }
  }

  Future<void> getTimeSlots(TimeSlotRequest request) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();
        var services = await _serviceSlotsUseCase.execute(request);
        timeSlots.value = services?.data ?? [];
        serviceStatus.value = ServiceStatus.dateDataLoaded;
        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  void dateSelected(ServiceData service, DateTime date) {
    selectedDate.value = date;
    selectedDateValue.value = DateFormat('dd/MM/yyyy').format(date);

    TimeSlotRequest request = TimeSlotRequest(
      categoryId: categoryId.value,
      tagId: service.tags.first.id.toString(),
      jobDate: DateFormat('yyyy-MM-dd').format(selectedDate.value),
      serviceId: service.servId.toString(),
    );

    getTimeSlots(request);
  }

  bool isAfter6PM(DateTime? date) {
    int hour = date?.hour ?? 0;
    int minute = date?.minute ?? 0;
    // Check if the time is after 6 PM
    if (hour >= 18 || (hour == 18 && minute > 0)) {
      return true;
    }
    return false;
  }
}
