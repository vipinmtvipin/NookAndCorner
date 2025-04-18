import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/extensions/string_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/utils/common_util.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/model/summery/job_login_responds.dart';
import 'package:customerapp/domain/model/summery/job_request.dart';
import 'package:customerapp/domain/model/summery/job_responds.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';
import 'package:customerapp/domain/usecases/service/service_by_tag_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_details_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_slots_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_tags_use_case.dart';
import 'package:customerapp/domain/usecases/summery/addons_use_case.dart';
import 'package:customerapp/domain/usecases/summery/apply_coupon_use_case.dart';
import 'package:customerapp/domain/usecases/summery/create_job_use_case.dart';
import 'package:customerapp/domain/usecases/summery/create_login_job_use_case.dart';
import 'package:customerapp/domain/usecases/summery/meta_use_case.dart';
import 'package:customerapp/domain/usecases/summery/summery_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

enum ServiceStatus {
  unknown,
  loaded,
  initiated,
  dateDataLoaded,
  couponApplied,
}

enum PaymentStatus {
  unknown,
  success,
  failed,
  processing,
}

class ServiceController extends BaseController {
  final ServiceDetailsByTagUseCase _serviceDetailsByTagUseCase;
  final ServiceDetailsUseCase _serviceDetailsUseCase;
  final ServiceTagsUseCase _serviceTagUseCase;
  final ServiceSlotsUseCase _serviceSlotsUseCase;

  final MetaUseCase _metaUseCase;
  final AddonsUseCase _addonsUseCase;
  final CreateJobUseCase _createJobUseCase;
  final CreateLoginJobUseCase _createLoginJobUseCase;
  final ApplyCouponUseCase _applyCouponUseCase;
  final SummeryUseCase _summeryUseCase;

  ServiceController(
    this._serviceDetailsByTagUseCase,
    this._serviceDetailsUseCase,
    this._serviceTagUseCase,
    this._serviceSlotsUseCase,
    this._metaUseCase,
    this._createJobUseCase,
    this._createLoginJobUseCase,
    this._applyCouponUseCase,
    this._addonsUseCase,
    this._summeryUseCase,
  );

  var cuponFocusNode = FocusNode();

  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<ServiceData>> serviceInfo = Rx([]);
  Rx<List<TimeSlotData>> timeSlots = Rx([]);
  Rx<List<TagData>> tagData = Rx([]);
  Rx<List<CouponData>> couponData = Rx([]);
  Rx<List<AddOnData>> addOnList = Rx([]);
  Rx<List<AddOnData>> addOns = Rx([]);
  Rx<MetasData> metaData = Rx(MetasData.empty());

  int calenderDayCount = 10;
  Rx<JobResponds> jobData = Rx(JobResponds.empty());
  Rx<JobLoginResponds> jobLoginData = Rx(JobLoginResponds.empty());
  Rx<ServiceData> selectedService = Rx(ServiceData.empty());
  Rx<DateTime> selectedDate = Rx(
    DateTime.now().add(Duration(days: 1)),
  );

  bool isDateChoose = false;

  // Rx<String> selectedDateValue = Rx('Select Date');
  var selectedDateValue = 'Select Date'.obs;
  var selectedTime = ''.obs;

  var serviceStatus = ServiceStatus.unknown.obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController summeryScrollController = ScrollController();

  var couponApplied = false.obs;
  var termsAndConditionApply = false.obs;
  var categoryId = "".obs;
  var categoryName = "".obs;
  var categoryDescription = "".obs;
  var categoryImage = "".obs;
  var convenienceFee = 0.0.obs;
  var baseConvenienceFee = 0.0;
  var advanceAmount = 0.0.obs;
  var goldenHourAmount = 0.0.obs;
  var grandTotal = 0.0.obs;
  var promotionAmount = 0.0.obs;
  var addOnsTotal = 0.0.obs;
  var serviceTotal = 0.0.obs;
  var advancePercentage = 0.0;
  var addOnConvenienceFee = 0.0.obs;

  var orderID = "".obs;
  var paymentType = "".obs;

  var jobID = "";

  var paymentStatus = PaymentStatus.unknown.obs;

  final sessionStorage = GetStorage();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var isLogin = false;
  var userVerified = false;

  var mobile = "";
  var email = "";

  var updateMobile = "";
  var updateEmail = "";

  @override
  void onClose() {
    super.onClose();
    cuponFocusNode.dispose();
    promoCodeController.clear();
    phoneController.clear();
    emailController.clear();
    scrollController.dispose();
    summeryScrollController.dispose();
    isDateChoose = false;
  }

  @override
  void onInit() {
    super.onInit();

    mobile = sessionStorage.read(StorageKeys.mobile) ?? "";
    email = sessionStorage.read(StorageKeys.email) ?? "";
    updateMobile = mobile;
    updateEmail = email;

    isLogin = sessionStorage.read(StorageKeys.loggedIn) ?? false;

    final arguments = Get.arguments as Map<String, dynamic>;

    categoryId.value = arguments['categoryId'] ?? '';
    categoryName.value = arguments['categoryName'] ?? '';
    categoryDescription.value = arguments['categoryDescription'] ?? '';
    categoryImage.value = arguments['categoryImage'] ?? '';

    initialApisCall();

    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == AppLifecycleState.paused.toString()) {
        if (paymentStatus.value == PaymentStatus.success) {
          Get.find<MainScreenController>().pendingJobs = true;
        }
      } else if (message == AppLifecycleState.resumed.toString()) {
        if (paymentStatus.value == PaymentStatus.success) {
          //   Get.find<MainScreenController>().pendingJobs = false;
        }
      }
      return null;
    });
  }

  void initialApisCall() {
    getServiceDetails(categoryId.value.toString());
    getServiceTags(categoryId.value.toString());
    getSummeryInfo();
    // _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    try {
      // List of permissions to request
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.scheduleExactAlarm,
      ].request();
    } catch (_) {}
  }

  Future<void> getServiceDetails(String categoryId,
      {bool fromTag = false}) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        var services = await _serviceDetailsUseCase.execute(categoryId);
        serviceInfo.value = services?.data ?? [];

        grandTotal.value =
            double.tryParse(serviceInfo.value.first.price ?? '0') ?? 0;

        serviceStatus.value = ServiceStatus.loaded;

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showServerErrorAlert(() {
          getServiceDetails(categoryId, fromTag: fromTag);
        });
      }
    } else {
      showOpenSettings();
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
        showServerErrorAlert(() {
          getServiceByTagClick(tagId);
        });
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

        if (services?.data != null) {
          List<TimeSlotData> timeSlotData = [];
          for (var i = 0; i < services!.data.length; i++) {
            var slotStart = services.data[i].slotStart;
            var slotStartLocal = slotStart?.toLocal();
            var timeSlot = TimeSlotData(
              slotStart: slotStartLocal,
              isSelected: services.data[i].isSelected,
              supervisors: services.data[i].supervisors,
            );
            timeSlotData.add(timeSlot);
          }
          timeSlots.value = timeSlotData;
        } else {
          timeSlots.value = services?.data ?? [];
        }

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

  ///Get basic summery info
  getSummeryInfo({bool isLoader = false}) async {
    if (await _connectivityService.isConnected()) {
      try {
        if (isLoader) {
          showLoadingDialog();
        }

        AddonRequest request = AddonRequest(
            status: 'active',
            subServiceId: selectedService.value.servId.toString(),
            offset: 0,
            limit: 20);

        final responds = await _summeryUseCase.execute(request);

        metaData.value = responds.item1.data ?? MetasData.empty();
        addOnList.value = responds.item2.data?.data ?? [];

        double servicePrice =
            double.tryParse(selectedService.value.price ?? '0') ?? 0;
        serviceTotal.value = servicePrice;

        double servicePercentage = servicePrice / 100;

        calenderDayCount =
            int.tryParse(metaData.value.calendarDays ?? '10') ?? 10;
        advancePercentage =
            double.tryParse(metaData.value.advancePercentage ?? '0') ?? 0;
        advanceAmount.value = servicePercentage * advancePercentage;
        advanceAmount.value =
            double.parse(advanceAmount.value.toStringAsFixed(2));

        double conveniencePercent =
            double.tryParse(metaData.value.conveniencePercentage ?? '0') ?? 0;
        convenienceFee.value = servicePercentage * conveniencePercent;
        convenienceFee.value =
            double.parse(convenienceFee.value.toStringAsFixed(2));

        baseConvenienceFee = convenienceFee.value;

        checkGoldenHour();
        calculateGrandTotal();

        if (isLoader) {
          hideLoadingDialog();
        }
      } catch (e) {
        if (isLoader) {
          hideLoadingDialog();
        }
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> applyCoupon(String code) async {
    if (couponApplied.value) {
      couponApplied.value = false;
      grandTotal.value = grandTotal.value + promotionAmount.value;
      couponData.value = [];
      promotionAmount.value = 0.0;
      promoCodeController.clear();

      double servicePercentage = grandTotal.value / 100;
      advanceAmount.value = servicePercentage * advancePercentage;
      advanceAmount.value =
          double.parse(advanceAmount.value.toStringAsFixed(2));
    } else {
      if (await _connectivityService.isConnected()) {
        try {
          showLoadingDialog();

          CouponRequest request = CouponRequest(
            slot: selectedDate.value.toString(),
            promotionName: code,
            serviceId: selectedService.value.servId.toString(),
          );

          var coupon = await _applyCouponUseCase.execute(request);
          if (coupon?.data.isNotEmpty ?? false) {
            couponData.value = coupon?.data ?? [];
            couponApplied.value = true;

            calculateGrandTotal();

            showToast(coupon?.message ?? 'Promo code applied successfully');
            try {
              CommonUtil().keyboardHide(Get.context!);
            } catch (e) {
              e.printError();
            }
          } else {
            couponApplied.value = false;
          }
          hideLoadingDialog();
        } catch (e) {
          couponApplied.value = false;
          hideLoadingDialog();
          showSnackBar("Error", e.toString(), Colors.black);
        }
      } else {
        showToast(LocalizationKeys.noNetwork.tr);
      }
    }
  }

  Future<void> createJob() async {
    if (await _connectivityService.isConnected()) {
      try {
        JobRequest request;
        var selectedCity = CityData.empty();
        final value = sessionStorage.read(StorageKeys.selectedCity);
        if (value != null) {
          selectedCity = CityData.fromJson(value);
        }

        var selectedTimeSlot = timeSlots.value.firstWhere((element) {
          return DateFormat('hh:mm aa').format(element.slotStart!) ==
              selectedTime.value;
        }, orElse: () => TimeSlotData.empty());

        var isGoldenHour = isAfter6PM(selectedTimeSlot.slotStart);

        List<AddOnAdd> addOnList = [];
        for (var e in addOns.value) {
          addOnList.add(
            AddOnAdd(
                addonId: e.addonId,
                addonPrice: double.tryParse(e.price ?? '0'),
                quantity: e.quantity,
                serviceId: selectedService.value.servId),
          );
        }

        if (isLogin) {
          var email = sessionStorage.read(StorageKeys.email) ?? '';
          var mobile = sessionStorage.read(StorageKeys.mobile) ?? '';

          if (email == null ||
              email.toString().isNullOrEmpty ||
              email.toString() == 'null') {
            email = emailController.text;
          }
          if (mobile == null ||
              mobile.toString().isNullOrEmpty ||
              mobile.toString() == 'null') {
            mobile = phoneController.text;
          }

          showLoadingDialog();
          request = JobRequest(
            addOns: addOnList,
            advanceAmount: advanceAmount.value,
            advancePercent:
                double.tryParse(metaData.value.advancePercentage ?? '0'),
            cityId: selectedCity.cityId,
            convenienceFee: convenienceFee.value,
            conveniencePercent:
                double.tryParse(metaData.value.conveniencePercentage ?? '0'),
            email: email,
            goldenHoursCharge: isGoldenHour ? goldenHourAmount.value : 0.0,
            isGolderHour: isGoldenHour,
            jobDate: selectedDate.value,
            jobDateOnly: selectedDate.value,
            name: sessionStorage.read(StorageKeys.username).toString(),
            overNightHikePercentage:
                double.tryParse(metaData.value.overNightHikePercentage ?? '0'),
            phoneNumber: mobile,
            price: grandTotal.value,
            promotionAmount:
                couponData.value.isEmpty ? null : promotionAmount.value,
            promotionId: couponData.value.isEmpty
                ? null
                : couponData.value.first.promotionId,
            promotionStatus:
                couponData.value.isEmpty ? null : couponData.value.first.status,
            serviceId: selectedService.value.servId.toString(),
            supervisors: selectedTimeSlot.supervisors ?? [],
            userId: sessionStorage.read(StorageKeys.userId).toString(),
            otpVerified: false,
          );

          var job = await _createLoginJobUseCase.execute(request);

          sessionStorage.write(StorageKeys.email, email);
          sessionStorage.write(StorageKeys.mobile, mobile);

          orderID.value = job?.data?.jobCreated?.txnId ?? "";
          jobID = job?.data?.jobCreated?.jobId.toString() ?? "";
          jobLoginData.value = job!;
        } else {
          showLoadingDialog();

          request = JobRequest(
            addOns: addOnList,
            advanceAmount: advanceAmount.value,
            advancePercent:
                double.tryParse(metaData.value.advancePercentage ?? '0'),
            cityId: selectedCity.cityId,
            convenienceFee: convenienceFee.value,
            conveniencePercent:
                double.tryParse(metaData.value.conveniencePercentage ?? '0'),
            email: updateEmail,
            goldenHoursCharge: isGoldenHour ? goldenHourAmount.value : 0.0,
            isGolderHour: isGoldenHour,
            jobDate: selectedDate.value,
            jobDateOnly: selectedDate.value,
            name: sessionStorage.read(StorageKeys.username) ?? '',
            overNightHikePercentage:
                double.tryParse(metaData.value.overNightHikePercentage ?? '0'),
            phoneNumber: updateMobile,
            price: grandTotal.value,
            promotionAmount:
                couponData.value.isEmpty ? null : promotionAmount.value,
            promotionId: couponData.value.isEmpty
                ? null
                : couponData.value.first.promotionId,
            promotionStatus:
                couponData.value.isEmpty ? null : couponData.value.first.status,
            serviceId: selectedService.value.servId.toString(),
            supervisors: selectedTimeSlot.supervisors ?? [],
            otpVerified: false,
          );
          var job = await _createJobUseCase.execute(request);

          sessionStorage.write(StorageKeys.email, updateEmail);
          sessionStorage.write(StorageKeys.mobile, updateMobile);
          orderID.value = job?.data?.jobCreated?.txnId ?? "";
          jobID = job?.data?.jobCreated?.jobId.toString() ?? "";
          jobData.value = job!;

          saveJobUserData();
        }

        hideLoadingDialog();

        if (couponData.value.isNotNullOrEmpty &&
            couponData.value.first.promotionType == 'free') {
          Get.toNamed(AppRoutes.confirmAddressScreen,
              arguments: {'jobId': jobID, 'from': 'payment'});
        } else {
          paymentType.value == "Advance";
          Get.toNamed(AppRoutes.paymentScreen, arguments: {
            'orderID': orderID.value,
            'paymentAmount': advanceAmount.value,
            'paymentType': "Advance",
          });
        }
      } catch (e) {
        hideLoadingDialog();
        Get.back();
        showSnackBar(
            "Warning", "${e.toString()}, Please login.", Colors.black54);
        if (e.toString().contains('User already exists')) {
          if (e.toString().contains('email address')) {
            await Get.toNamed(AppRoutes.loginScreen, arguments: {
              'from': AppRoutes.summeryScreen,
              "flag": "email",
              "email": updateEmail,
              "phone": updateMobile,
            });
          } else {
            await Get.toNamed(AppRoutes.loginScreen, arguments: {
              'from': AppRoutes.summeryScreen,
              "flag": "mobile",
              "email": updateEmail,
              "phone": updateMobile,
            });
          }

          if (isLogin) {
            createJob();
          }
        } else if (e.toString().contains('Verify phone number')) {
          await Get.toNamed(AppRoutes.loginScreen, arguments: {
            'from': AppRoutes.summeryScreen,
            "flag": "mobileJob",
            "email": updateEmail,
            "phone": updateMobile,
          });

          if (userVerified) {
            createJobVerifyOtp();
          }
        }
      }
    } else {
      showOpenSettings();
    }
  }

  Future<void> createJobVerifyOtp() async {
    if (await _connectivityService.isConnected()) {
      try {
        JobRequest request;
        var selectedCity = CityData.empty();
        final value = sessionStorage.read(StorageKeys.selectedCity);
        if (value != null) {
          selectedCity = CityData.fromJson(value);
        }

        var selectedTimeSlot = timeSlots.value.firstWhere((element) {
          return DateFormat('hh:mm aa').format(element.slotStart!) ==
              selectedTime.value;
        }, orElse: () => TimeSlotData.empty());

        var isGoldenHour = isAfter6PM(selectedTimeSlot.slotStart);

        List<AddOnAdd> addOnList = [];
        for (var e in addOns.value) {
          addOnList.add(
            AddOnAdd(
                addonId: e.addonId,
                addonPrice: double.tryParse(e.price ?? '0'),
                quantity: e.quantity,
                serviceId: selectedService.value.servId),
          );
        }

        double servicePercentage = grandTotal.value / 100;
        advanceAmount.value = servicePercentage * advancePercentage;
        advanceAmount.value =
            double.parse(advanceAmount.value.toStringAsFixed(2));

        showLoadingDialog();

        if (isLogin) {
          var email = sessionStorage.read(StorageKeys.email) ?? '';
          var mobile = sessionStorage.read(StorageKeys.mobile) ?? '';

          if (email == null ||
              email.toString().isNullOrEmpty ||
              email.toString() == 'null') {
            email = updateEmail;
          }
          if (mobile == null ||
              mobile.toString().isNullOrEmpty ||
              mobile.toString() == 'null') {
            mobile = updateMobile;
          }

          request = JobRequest(
            addOns: addOnList,
            advanceAmount: advanceAmount.value,
            advancePercent:
                double.tryParse(metaData.value.advancePercentage ?? '0'),
            cityId: selectedCity.cityId,
            convenienceFee: convenienceFee.value,
            conveniencePercent:
                double.tryParse(metaData.value.conveniencePercentage ?? '0'),
            email: email,
            goldenHoursCharge: isGoldenHour ? goldenHourAmount.value : 0.0,
            isGolderHour: isGoldenHour,
            jobDate: selectedDate.value,
            jobDateOnly: selectedDate.value,
            name: sessionStorage.read(StorageKeys.username).toString(),
            overNightHikePercentage:
                double.tryParse(metaData.value.overNightHikePercentage ?? '0'),
            phoneNumber: mobile,
            price: grandTotal.value,
            promotionAmount:
                couponData.value.isEmpty ? null : promotionAmount.value,
            promotionId: couponData.value.isEmpty
                ? null
                : couponData.value.first.promotionId,
            promotionStatus:
                couponData.value.isEmpty ? null : couponData.value.first.status,
            serviceId: selectedService.value.servId.toString(),
            supervisors: selectedTimeSlot.supervisors ?? [],
            userId: sessionStorage.read(StorageKeys.userId).toString(),
            otpVerified: true,
          );

          var job = await _createLoginJobUseCase.execute(request);

          sessionStorage.write(StorageKeys.email, email);
          sessionStorage.write(StorageKeys.mobile, mobile);

          orderID.value = job?.data?.jobCreated?.txnId ?? "";
          jobID = job?.data?.jobCreated?.jobId.toString() ?? "";
          jobLoginData.value = job!;
        } else {
          request = JobRequest(
            addOns: addOnList,
            advanceAmount: advanceAmount.value,
            advancePercent:
                double.tryParse(metaData.value.advancePercentage ?? '0'),
            cityId: selectedCity.cityId,
            convenienceFee: convenienceFee.value,
            conveniencePercent:
                double.tryParse(metaData.value.conveniencePercentage ?? '0'),
            email: updateEmail,
            goldenHoursCharge: isGoldenHour ? goldenHourAmount.value : 0.0,
            isGolderHour: isGoldenHour,
            jobDate: selectedDate.value,
            jobDateOnly: selectedDate.value,
            name: sessionStorage.read(StorageKeys.username) ?? '',
            overNightHikePercentage:
                double.tryParse(metaData.value.overNightHikePercentage ?? '0'),
            phoneNumber: updateMobile,
            price: grandTotal.value,
            promotionAmount:
                couponData.value.isEmpty ? null : promotionAmount.value,
            promotionId: couponData.value.isEmpty
                ? null
                : couponData.value.first.promotionId,
            promotionStatus:
                couponData.value.isEmpty ? null : couponData.value.first.status,
            serviceId: selectedService.value.servId.toString(),
            supervisors: selectedTimeSlot.supervisors ?? [],
            otpVerified: true,
          );
          var job = await _createJobUseCase.execute(request);

          sessionStorage.write(StorageKeys.email, updateMobile);
          sessionStorage.write(StorageKeys.mobile, updateMobile);

          orderID.value = job?.data?.jobCreated?.txnId ?? "";
          jobID = job?.data?.jobCreated?.jobId.toString() ?? "";
          jobData.value = job!;

          saveJobUserData();
        }

        hideLoadingDialog();

        if (couponData.value.isNotNullOrEmpty &&
            couponData.value.first.promotionType == 'free') {
          Get.toNamed(AppRoutes.confirmAddressScreen,
              arguments: {'jobId': jobID, 'from': 'payment'});
        } else {
          paymentType.value == "Advance";
          Get.toNamed(AppRoutes.paymentScreen, arguments: {
            'orderID': orderID.value,
            'paymentAmount': advanceAmount.value,
            'paymentType': "Advance",
          });
        }
      } catch (e) {
        hideLoadingDialog();
        showSnackBar("Warning", "${e.toString()}.", Colors.black54);
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  bool onPhoneChanged() {
    return GetUtils.isNullOrBlank(phoneController.text)! ||
        phoneController.text.length < 10;
  }

  bool onEmailChanged() {
    return GetUtils.isEmail(emailController.text);
  }

  void dateSelected(ServiceData service, DateTime date) {
    isDateChoose = true;
    selectedDate.value = date;
    selectedDateValue.value = DateFormat('dd/MM/yyyy').format(date);

    var userId = sessionStorage.read(StorageKeys.userId).toString();
    if (userId.isNullOrEmpty) {
      userId = '';
    }
    TimeSlotRequest request = TimeSlotRequest(
      categoryId: categoryId.value,
      tagId: service.tags.first.id.toString(),
      jobDate:
          '${DateFormat('yyyy-MM-dd').format(selectedDate.value)} 00:00:00.000+0530',
      serviceId: service.servId.toString(),
      userId: userId,
    );

    getTimeSlots(request);

    if (serviceStatus.value == ServiceStatus.couponApplied) {
      applyCoupon(couponData.value.first.promotionName ?? '');
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
      addOnConvenienceFee.value = 0;
      addOnConvenienceFee.value = convenienceFees;
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

    var singleAddon = false;
    if (count == -1 && quantity <= 1) {
      if (currentAddOn.length == 1) {
        singleAddon = true;
        var convenienceFees = 0.0;
        double conveniencePercent =
            double.tryParse(metaData.value.conveniencePercentage ?? '0') ?? 0;

        double addonPrice = double.tryParse(originAddon.price ?? '0') ?? 0.0;

        double addOnPercentage = addonPrice / 100;
        var convenienceValue = (addOnPercentage * conveniencePercent);
        convenienceFees = double.parse(convenienceValue.toStringAsFixed(2));

        addOns.value = [];
        addOnsTotal.value = 0;

        addOnConvenienceFee.value = 0;
        addOnConvenienceFee.value = convenienceFees;

        calculateRemoveGrandTotal();
      } else {
        currentAddOn.removeAt(index);
        addOns.value = [];
        addOns.value = currentAddOn;
      }
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

    if (singleAddon == false) {
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
        convenienceFees =
            convenienceFees + double.parse(convenienceValue.toStringAsFixed(2));
      }

      addOnsTotal.value = 0;
      addOnsTotal.value = price;
      addOnConvenienceFee.value = 0;
      addOnConvenienceFee.value = convenienceFees;

      calculateGrandTotal();
    }
  }

  void calculateGrandTotal() {
    var couponAmount = 0.0;

    convenienceFee.value = baseConvenienceFee + addOnConvenienceFee.value;
    var servicePrice = double.tryParse(selectedService.value.price ?? '0') ?? 0;
    serviceTotal.value = servicePrice + addOnsTotal.value;

    var orderTotal =
        serviceTotal.value + convenienceFee.value + goldenHourAmount.value;

    if (couponData.value.isNotEmpty) {
      if (couponData.value.first.promotionType == 'percent') {
        double servicePercentage = orderTotal / 100;
        var couponPercentage = couponData.value.first.discountOfferPrice ?? 0.0;
        couponAmount = servicePercentage * couponPercentage;
        couponAmount = double.parse(couponAmount.toStringAsFixed(2));
        promotionAmount.value = couponAmount;
      } else if (couponData.value.first.promotionType == 'free') {
        couponAmount = orderTotal;
        promotionAmount.value = couponAmount;
      } else {
        couponAmount = couponData.value.first.discountOfferPrice ?? 0.0;
        promotionAmount.value = couponAmount;
      }
    }

    grandTotal.value = orderTotal - couponAmount;

    if (grandTotal.value == 0.0) {
      advanceAmount.value = 0.0;
    } else {
      double servicePercentage = grandTotal.value / 100;
      advanceAmount.value = servicePercentage * advancePercentage;
      advanceAmount.value =
          double.parse(advanceAmount.value.toStringAsFixed(2));
    }
  }

  void calculateRemoveGrandTotal() {
    var couponAmount = 0.0;

    convenienceFee.value = baseConvenienceFee;
    var servicePrice = double.tryParse(selectedService.value.price ?? '0') ?? 0;
    serviceTotal.value = servicePrice;

    var orderTotal =
        serviceTotal.value + convenienceFee.value + goldenHourAmount.value;

    if (couponData.value.isNotEmpty) {
      if (couponData.value.first.promotionType == 'percent') {
        double servicePercentage = orderTotal / 100;
        var couponPercentage = couponData.value.first.discountOfferPrice ?? 0.0;
        couponAmount = servicePercentage * couponPercentage;
        couponAmount = double.parse(couponAmount.toStringAsFixed(2));
        promotionAmount.value = couponAmount;
      } else if (couponData.value.first.promotionType == 'free') {
        couponAmount = orderTotal;
        promotionAmount.value = couponAmount;
      } else {
        couponAmount = couponData.value.first.discountOfferPrice ?? 0.0;
        promotionAmount.value = couponAmount;
      }
    }

    grandTotal.value = orderTotal - couponAmount;

    if (grandTotal.value == 0.0) {
      advanceAmount.value = 0.0;
    } else {
      double servicePercentage = grandTotal.value / 100;
      advanceAmount.value = servicePercentage * advancePercentage;
      advanceAmount.value =
          double.parse(advanceAmount.value.toStringAsFixed(2));
    }
  }

  void saveJobUserData() {
    if (jobData.value.data != null) {
      sessionStorage.write(StorageKeys.loggedIn, true);
      sessionStorage.write(
          StorageKeys.token, jobData.value.data?.accessToken ?? "");
      sessionStorage.write(
          StorageKeys.userId, jobData.value.data?.jobData?.userId ?? "");

      try {
        Get.find<MainScreenController>().loggedIn.value = true;
        Get.find<MainScreenController>().updatePushToken();
      } catch (e) {
        Logger.e("Error in controller", e);
      }
    }
  }

  void checkGoldenHour() {
    double servicePrice =
        double.tryParse(selectedService.value.price ?? '0') ?? 0;
    double servicePercentage = servicePrice / 100;

    double nightHikePercent =
        double.tryParse(metaData.value.overNightHikePercentage ?? '0') ?? 0;

    var selectedTimeSlot = timeSlots.value.firstWhere((element) {
      return DateFormat('hh:mm aa').format(element.slotStart!) ==
          selectedTime.value;
    }, orElse: () => TimeSlotData.empty());

    var isGoldenHour = isAfter6PM(selectedTimeSlot.slotStart);

    if (isGoldenHour) {
      goldenHourAmount.value = servicePercentage * nightHikePercent;
      goldenHourAmount.value =
          double.parse(goldenHourAmount.value.toStringAsFixed(2));
    } else {
      goldenHourAmount.value = 0.0;
    }

    calculateGrandTotal();
  }

  void clearAllControllerData() {
    addOns.value = [];
    addOnList.value = [];
    addOnsTotal.value = 0;
    serviceTotal.value = 0;
    termsAndConditionApply.value = false;
    addOnConvenienceFee.value = 0;
    selectedDateValue.value = '';
    couponApplied.value = false;
    advanceAmount.value = 0;
    convenienceFee.value = 0;
    grandTotal.value = 0;
    goldenHourAmount.value = 0;
    couponData.value = [];
    promoCodeController.clear();
    phoneController.clear();
    emailController.clear();
    isDateChoose = false;
    promotionAmount.value = 0.0;
    userVerified = false;
  }
}
