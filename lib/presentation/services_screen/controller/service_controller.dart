import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/service/service_details_responds.dart';
import 'package:customerapp/domain/model/service/tag_responds.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/model/summery/job__login_responds.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

enum ServiceStatus {
  unknown,
  loaded,
  initiated,
  dateDataLoaded,
  couponApplied,
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

  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<ServiceData>> serviceInfo = Rx([]);
  Rx<List<TimeSlotData>> timeSlots = Rx([]);
  Rx<List<TagData>> tagData = Rx([]);
  Rx<List<CouponData>> couponData = Rx([]);
  Rx<List<AddOnData>> addOnList = Rx([]);
  Rx<List<AddOnData>> addOns = Rx([]);
  Rx<MetasData> metaData = Rx(MetasData.empty());
  Rx<JobResponds> jobData = Rx(JobResponds.empty());
  Rx<JobLoginResponds> jobLoginData = Rx(JobLoginResponds.empty());
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
  var convenienceFee = 0.0.obs;
  var advanceAmount = 0.0.obs;
  var goldenHourAmount = 0.0.obs;
  var grandTotal = 0.0.obs;
  var addOnsTotal = 0.0.obs;

  final sessionStorage = GetStorage();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var isLogin = false;

  @override
  void onClose() {
    super.onClose();
    promoCodeController.clear();
    phoneController.clear();
    emailController.clear();
  }

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

        grandTotal.value =
            double.tryParse(serviceInfo.value.first.price ?? '0') ?? 0;

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

  ///Get basic summery info
  getSummeryInfo() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

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

        grandTotal.value = servicePrice;

        double servicePercentage = servicePrice / 100;

        double advancePercentage =
            double.tryParse(metaData.value.advancePercentage ?? '0') ?? 0;
        advanceAmount.value = servicePercentage * advancePercentage;

        double conveniencePercent =
            double.tryParse(metaData.value.advancePercentage ?? '0') ?? 0;
        convenienceFee.value = servicePercentage * conveniencePercent;

        double nightHikePercent =
            double.tryParse(metaData.value.overNightHikePercentage ?? '0') ?? 0;
        var isGoldenHour = isAfter6PM(selectedDate.value);
        if (isGoldenHour) {
          goldenHourAmount.value = servicePercentage * nightHikePercent;
        }

        calculateGrandTotal();

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> applyCoupon(String code) async {
    if (couponApplied.value) {
      couponApplied.value = false;
      grandTotal.value = grandTotal.value -
          double.tryParse(couponData.value.first.discountOfferPrice ?? '0')!;
      couponData.value = [];
      promoCodeController.clear();
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

            var discount = double.tryParse(
                    couponData.value.first.discountOfferPrice ?? '0') ??
                0;
            calculateGrandTotal();
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
        showLoadingDialog();
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

        var isGoldenHour = isAfter6PM(selectedDate.value);

        List<AddOnAdd> addOnList = [];
        for (var e in addOns.value) {
          addOnList.add(
            AddOnAdd(
                addonId: e.addonId,
                addonPrice: e.price,
                quantity: e.quantity,
                serviceId: selectedService.value.servId),
          );
        }

        if (isLogin) {
          request = JobRequest(
            addOns: addOnList,
            advanceAmount: metaData.value.advancePercentage,
            advancePercent: advanceAmount.toString(),
            cityId: selectedCity.cityId,
            convenienceFee: convenienceFee.toString(),
            conveniencePercent: metaData.value.conveniencePercentage,
            email: sessionStorage.read(StorageKeys.email),
            goldenHoursCharge:
                isGoldenHour ? goldenHourAmount.value.toString() : "0",
            isGolderHour: isGoldenHour,
            jobDate: selectedDate.value,
            jobDateOnly: selectedDate.value,
            name: sessionStorage.read(StorageKeys.username),
            overNightHikePercentage: metaData.value.overNightHikePercentage,
            phoneNumber: sessionStorage.read(StorageKeys.mobile),
            price: selectedService.value.price,
            serviceId: selectedService.value.servId.toString(),
            supervisors: selectedTimeSlot.supervisors ?? [],
            userId: sessionStorage.read(StorageKeys.userId),
          );

          var job = await _createLoginJobUseCase.execute(request);

          jobLoginData.value = job!;
        } else {
          request = JobRequest(
            addOns: addOnList,
            advanceAmount: metaData.value.advancePercentage,
            advancePercent: advanceAmount.toString(),
            cityId: selectedCity.cityId,
            convenienceFee: convenienceFee.toString(),
            conveniencePercent: metaData.value.conveniencePercentage,
            email: emailController.text,
            goldenHoursCharge:
                isGoldenHour ? goldenHourAmount.value.toString() : "0",
            isGolderHour: isGoldenHour,
            jobDate: selectedDate.value,
            jobDateOnly: selectedDate.value,
            name: sessionStorage.read(StorageKeys.username),
            overNightHikePercentage: metaData.value.overNightHikePercentage,
            phoneNumber: phoneController.text,
            price: selectedService.value.price,
            promotionAmount: couponData.value.isEmpty
                ? ''
                : couponData.value.first.discountOfferPrice,
            promotionId: couponData.value.isEmpty
                ? ''
                : couponData.value.first.promotionId.toString(),
            promotionStatus:
                couponData.value.isEmpty ? '' : couponData.value.first.status,
            serviceId: selectedService.value.servId.toString(),
            supervisors: selectedTimeSlot.supervisors ?? [],
          );
          var job = await _createJobUseCase.execute(request);

          jobData.value = job!;

          sessionStorage.write(StorageKeys.loggedIn, true);
          // sessionStorage.write(StorageKeys.token, jobData.value.data.token);
          sessionStorage.write(StorageKeys.email, emailController.text);
          sessionStorage.write(StorageKeys.mobile, phoneController.text);
        }

        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        showSnackBar("Error", e.toString(), Colors.black54);
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
      for (var e in currentAddOn) {
        var addon = addOnList.value.firstWhere((element) {
          return element.addonId == e.addonId;
        });
        price = price + double.tryParse(addon.price ?? '0')! * e.quantity!;
      }
      addOnsTotal.value = 0;
      addOnsTotal.value = price;
      grandTotal.value = grandTotal.value + addOnsTotal.value;
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
    for (var e in currentAddOn) {
      var addon = addOnList.value.firstWhere((element) {
        return element.addonId == e.addonId;
      });
      price = price + double.tryParse(addon.price ?? '0')! * e.quantity!;
    }
    addOnsTotal.value = 0;
    addOnsTotal.value = price;

    calculateGrandTotal();
  }

  void calculateGrandTotal() {
    var serviceTotal = double.tryParse(selectedService.value.price ?? '0') ?? 0;
    var couponAmount = 0.0;
    if (couponData.value.isNotEmpty) {
      couponAmount =
          double.tryParse(couponData.value.first.discountOfferPrice ?? '0') ??
              0;
    }

    grandTotal.value = (serviceTotal +
        convenienceFee.value +
        addOnsTotal.value +
        goldenHourAmount.value -
        couponAmount);
  }
}
