import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';
import 'package:customerapp/domain/usecases/my_job/cancel_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/my_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/rating_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/reschedule_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/review_job_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_slots_use_case.dart';
import 'package:customerapp/domain/usecases/summery/summery_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

enum MyBookingStatus { unknown, scheduled, pending, cancelled, completed }

enum MyBookingState { loading, loaded, error }

class MyBookingController extends BaseController {
  final MyJobUseCase _myJobUseCase;
  final SummeryUseCase _summeryUseCase;
  final ServiceSlotsUseCase _serviceSlotsUseCase;

  final CancelJobUseCase _cancelJobUseCase;
  final RatingJobUseCase _ratingJobUseCase;
  final RescheduleJobUseCase _rescheduleJobUseCase;
  final ReviewJobUseCase _reviewJobUseCase;

  MyBookingController(
    this._myJobUseCase,
    this._summeryUseCase,
    this._serviceSlotsUseCase,
    this._cancelJobUseCase,
    this._ratingJobUseCase,
    this._rescheduleJobUseCase,
    this._reviewJobUseCase,
  );

  var screenTitle = 'My Bookings'.obs;
  var screenType = MyBookingStatus.unknown;
  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<MyJobData>> jobList = Rx([]);
  Rx<MyJobData> selectedJob = Rx(MyJobData.empty());
  final sessionStorage = GetStorage();

  Rx<List<AddOnData>> addOnList = Rx([]);
  Rx<List<AddOnData>> addOns = Rx([]);
  Rx<MetasData> metaData = Rx(MetasData.empty());
  var convenienceFee = 0.0.obs;
  var advanceAmount = 0.0.obs;
  var goldenHourAmount = 0.0.obs;
  var grandTotal = 0.0.obs;
  var addOnsTotal = 0.0.obs;
  Rx<DateTime> selectedDate = Rx(
    DateTime.now().add(Duration(days: 1)),
  );
  var selectedDateValue = 'Select Date'.obs;
  var selectedTime = ''.obs;
  Rx<List<TimeSlotData>> timeSlots = Rx([]);
  var serviceStatus = ServiceStatus.unknown.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;

    if (arguments['title'] == MyBookingStatus.scheduled.name) {
      screenTitle.value = 'Scheduled Booking';
      screenType = MyBookingStatus.scheduled;
    } else if (arguments['title'] == MyBookingStatus.pending.name) {
      screenTitle.value = 'Pending Booking';
      screenType = MyBookingStatus.pending;
    } else if (arguments['title'] == MyBookingStatus.cancelled.name) {
      screenTitle.value = 'Cancelled Booking';
      screenType = MyBookingStatus.cancelled;
    } else if (arguments['title'] == MyBookingStatus.completed.name) {
      screenTitle.value = 'Completed Booking';
      screenType = MyBookingStatus.completed;
    }

    getJobs();
  }

  Future<void> getJobs() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var userId = sessionStorage.read(StorageKeys.userId);
        var request = MyJobRequest(
            userId: userId.toString(), bookingStatus: screenType.name);
        var jobData = await _myJobUseCase.execute(request);
        jobList.value = jobData?.data ?? [];

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> getBasicInfo() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        AddonRequest request = AddonRequest(
            status: 'active',
            subServiceId: selectedJob.value.serviceId.toString(),
            offset: 0,
            limit: 20);

        final responds = await _summeryUseCase.execute(request);

        metaData.value = responds.item1.data ?? MetasData.empty();
        addOnList.value = responds.item2.data?.data ?? [];

        double servicePrice = selectedJob.value.servicePrice?.price ?? 0.0;

        double servicePercentage = servicePrice / 100;

        double advancePercentage =
            double.tryParse(metaData.value.advancePercentage ?? '0') ?? 0;
        advanceAmount.value = servicePercentage * advancePercentage;
        advanceAmount.value =
            double.parse(advanceAmount.value.toStringAsFixed(2));

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  void dateSelected(MyJobData service, DateTime date) {
    selectedDate.value = date;
    selectedDateValue.value = DateFormat('dd/MM/yyyy').format(date);

    TimeSlotRequest request = TimeSlotRequest(
      categoryId: selectedJob.value.serviceId.toString(),
      //   tagId: service.t.first.id.toString(),
      jobDate: DateFormat('yyyy-MM-dd').format(selectedDate.value),
      serviceId: service.serviceId.toString(),
    );

    getTimeSlots(request);
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

  Future<void> cancelJob() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();
        var services =
            await _cancelJobUseCase.execute(selectedJob.value.jobId.toString());

        if (services?.success == true) {
          showToast('Job Cancelled Successfully');
          Get.back();
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

  Future<void> reviewJob(String comment) async {
    if (await _connectivityService.isConnected()) {
      try {
        JobCommentRequest request = JobCommentRequest(
          jobId: selectedJob.value.jobId.toString(),
          comment: comment,
          userId: sessionStorage.read(StorageKeys.userId),
        );

        showLoadingDialog();
        var services = await _reviewJobUseCase.execute(request);

        if (services?.success == true) {
          showToast('Your review recorded!');
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

  Future<void> ratingJob(String rating) async {
    if (await _connectivityService.isConnected()) {
      try {
        JobCommentRequest request = JobCommentRequest(
          jobId: selectedJob.value.jobId.toString(),
          comment: rating,
          userId: sessionStorage.read(StorageKeys.userId),
        );

        showLoadingDialog();
        var services = await _ratingJobUseCase.execute(request);

        if (services?.success == true) {
          showToast('Your rating recorded!');
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

  Future<void> reScheduleJob() async {
    if (await _connectivityService.isConnected()) {
      try {
        var selectedTimeSlot = timeSlots.value.firstWhere((element) {
          return DateFormat('hh:mm aa').format(element.slotStart!) ==
              selectedTime.value;
        }, orElse: () => TimeSlotData.empty());

        ReScheduleJobRequest request = ReScheduleJobRequest(
          goldenHourAdded: null,
          supervisors: selectedTimeSlot.supervisors ?? [],
          jobId: selectedJob.value.jobId.toString(),
          jobDate: DateFormat('yyyy-MM-dd').format(selectedDate.value),
        );

        showLoadingDialog();

        var services = await _rescheduleJobUseCase.execute(request);

        if (services?.success == true) {
          showToast('Job Rescheduled Successfully');
          var data = 'vipin';
          Get.back(result: data);
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

  bool isAfter6PM(DateTime? date) {
    int hour = date?.hour ?? 0;
    int minute = date?.minute ?? 0;
    // Check if the time is after 6 PM
    if (hour >= 18 || (hour == 18 && minute > 0)) {
      return true;
    }
    return false;
  }

  void calculateGrandTotal() {
    grandTotal.value = (convenienceFee.value + addOnsTotal.value);
  }

  void addAddOn(AddOnData addonData) {
    var currentAddOn = addOns.value;

    // need to check if the addon is already added
    var addon = addOns.value.firstWhere((element) {
      return element.addonId == addonData.addonId;
    }, orElse: () => AddOnData.empty());

    if (addon.addonId != 0) {
      updateAddOnQuantity(addonData, 1);
      return;
    } else {
      currentAddOn.add(addonData.copyWith(
        titile: addonData.titile,
        quantity: 1,
        price: addonData.price,
        addonId: addonData.addonId,
      ));
      addOns.value = [];
      addOns.value = currentAddOn;

      var price = 0.0;
      var convenienceFees = 0.0;
      double conveniencePercent =
          double.tryParse(metaData.value.conveniencePercentage ?? '0') ?? 0;
      for (var e in currentAddOn) {
        var addon = addOnList.value.firstWhere((element) {
          return element.addonId == e.addonId;
        });
        double addonPrice = double.tryParse(addon.price ?? '0') ?? 0.0;

        price = price + (addonPrice * e.quantity!);

        double addOnPercentage = addonPrice / 100;
        var convenienceValue =
            (addOnPercentage * conveniencePercent) * e.quantity!;
        convenienceFees = double.parse(convenienceValue.toStringAsFixed(2));
      }
      addOnsTotal.value = 0;
      addOnsTotal.value = price;
      convenienceFee.value = 0;
      convenienceFee.value = convenienceFees;
      calculateGrandTotal();
    }
  }

  void updateAddOnQuantity(AddOnData addonData, int count) {
    var index = addOns.value.indexWhere((element) {
      return element.addonId == addonData.addonId;
    });

    var originAddon = addOnList.value.firstWhere((element) {
      return element.addonId == addonData.addonId;
    });

    var quantity = addOns.value[index].quantity ?? 1;

    var currentAddOn = addOns.value;

    if (count == -1 && quantity <= 1) {
      currentAddOn.removeAt(index);
      addOns.value = [];
      addOns.value = currentAddOn;
    } else if (count == -1) {
      var newQuantity = quantity - 1;
      var price = double.tryParse(originAddon.price ?? '0')! * newQuantity;
      currentAddOn[index] = currentAddOn[index].copyWith(
        quantity: newQuantity,
        price: price.toString(),
      );
      addOns.value = [];
      addOns.value = currentAddOn;
    } else {
      var newQuantity = quantity + 1;
      var price = double.tryParse(originAddon.price ?? '0')! * newQuantity;

      currentAddOn[index] = currentAddOn[index].copyWith(
        quantity: newQuantity,
        price: price.toString(),
      );

      addOns.value = [];
      addOns.value = currentAddOn;
    }

    var price = 0.0;
    var convenienceFees = 0.0;
    double conveniencePercent =
        double.tryParse(metaData.value.conveniencePercentage ?? '0') ?? 0;

    for (var e in currentAddOn) {
      var addon = addOnList.value.firstWhere((element) {
        return element.addonId == e.addonId;
      });

      double addonPrice = double.tryParse(addon.price ?? '0') ?? 0.0;

      price = price + (addonPrice * e.quantity!);

      double addOnPercentage = addonPrice / 100;
      var convenienceValue =
          (addOnPercentage * conveniencePercent) * e.quantity!;
      convenienceFees = double.parse(convenienceValue.toStringAsFixed(2));
    }
    addOnsTotal.value = 0;
    addOnsTotal.value = price;
    convenienceFee.value = 0;
    convenienceFee.value = convenienceFees;
    calculateGrandTotal();
  }
}