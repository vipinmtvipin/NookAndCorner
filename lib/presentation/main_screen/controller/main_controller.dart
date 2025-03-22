import 'dart:async';

import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/bool_extension.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/notifications/notification_msg_util.dart';
import 'package:customerapp/domain/model/home/active_banner_responds.dart';
import 'package:customerapp/domain/model/home/city_responds.dart';
import 'package:customerapp/domain/model/home/city_service_responds.dart';
import 'package:customerapp/domain/model/home/mid_banner_responds.dart';
import 'package:customerapp/domain/model/home/push_request.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/model/settings/review_request.dart';
import 'package:customerapp/domain/model/settings/reviews_responds.dart';
import 'package:customerapp/domain/usecases/home/city_service_use_case.dart';
import 'package:customerapp/domain/usecases/home/home_use_case.dart';
import 'package:customerapp/domain/usecases/home/push_token_use_case.dart';
import 'package:customerapp/domain/usecases/home/reviews_list_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/my_job_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/main_screen/widgets/city_bottomsheet.dart';
import 'package:customerapp/presentation/my_job_screen/controller/mybooking_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

enum HomeStatus {
  unknown,
  loaded,
  initiated,
}

class MainScreenController extends BaseController {
  final HomeUseCase _homeUseCase;
  final CityServiceUseCase _cityServiceUseCase;
  final PushTokenUseCase _pushTokenUseCase;

  final ReviewsListUseCase _reviewsUseCase;
  final MyJobUseCase _myJobUseCase;
  MainScreenController(
    this._homeUseCase,
    this._cityServiceUseCase,
    this._pushTokenUseCase,
    this._reviewsUseCase,
    this._myJobUseCase,
  );
  final sessionStorage = GetStorage();
  late final _connectivityService = getIt<ConnectivityService>();

  var homeStatus = HomeStatus.unknown.obs;
  Rx<List<CityData>> cityInfo = Rx([]);
  Timer? _jobTimer;
  Rx<CityData> selectedCity = Rx(CityData());
  Rx<List<BannerData>> activeBanners = Rx([]);
  Rx<List<MidBannerData>> midBanners = Rx([]);
  Rx<List<CityServiceData>> cityServices = Rx([]);
  Rx<bool> loggedIn = Rx(false);
  Rx<int> reviewCount = Rx(0);
  Rx<bool> forceCitySelection = Rx(false);
  bool pendingJobs = false;
  bool pendingJobsRegistered = false;
  bool pendingPayments = false;
  bool pendingPaymentRegistered = false;

  Rx<List<ReviewData>> reviewList = Rx<List<ReviewData>>([]);
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    sessionStorage.write(StorageKeys.pendingJobCount, 1);
    sessionStorage.write(StorageKeys.pendingPaymentCount, 1);

    loggedIn.value = sessionStorage.read(StorageKeys.loggedIn) ?? false;
    final value = sessionStorage.read(StorageKeys.selectedCity);
    if (value != null) {
      selectedCity.value = CityData.fromJson(value);
    }
    super.onInit();

    ever(forceCitySelection, (value) {
      if (value == true) {
        if (selectedCity.value.cityId == null ||
            selectedCity.value.cityId == 0) {
          showCityPopup();
        }
        getPendingJobs();
      }
      forceCitySelection.value = false;
    });
  }

  @override
  void onReady() {
    super.onReady();
    getCity();
    getReviews('5', '0', "", false);
    updatePushToken();
    startPendingJobTimer();

    _requestMultiplePermissions();
  }

  showPendingNotification() async {
    try {
      int countPendingJobs =
          sessionStorage.read(StorageKeys.pendingJobCount) ?? 0;
      int countPendingPayments =
          sessionStorage.read(StorageKeys.pendingPaymentCount) ?? 0;

      if (pendingJobs.absolute && countPendingJobs > 0) {
        await NotificationMsgUtil.parse(
          RemoteNotification(
            title: 'Reminder: Pending Job',
            body: 'You have a pending job, please confirm the address.',
          ),
          payload: 'pending_jobs',
        );

        if (!pendingJobsRegistered) {
          pendingJobsRegistered = true;
          await Workmanager().registerPeriodicTask(
            'PendingNotification',
            'PendingNotification',
            constraints: Constraints(
              networkType: NetworkType.not_required,
              requiresBatteryNotLow: false,
              requiresCharging: false,
            ),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );
        }
      } else {
        Workmanager().cancelByUniqueName('PendingNotification');
      }

      if (pendingPayments.absolute && countPendingPayments > 0) {
        await NotificationMsgUtil.parse(
          RemoteNotification(
            title: 'Payment Due',
            body:
                'Hi there! Just a quick reminder about your balance service payment, please click here when you can. Thanks!',
          ),
          payload: 'pending_payment',
        );

        if (!pendingPaymentRegistered) {
          pendingPaymentRegistered = true;
          await Workmanager().registerPeriodicTask(
            'PaymentPendingNotification',
            'PaymentPendingNotification',
            constraints: Constraints(
              networkType: NetworkType.not_required,
              requiresBatteryNotLow: false,
              requiresCharging: false,
            ),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          );
        }
      } else {
        Workmanager().cancelByUniqueName('PaymentPendingNotification');
      }
    } catch (e) {
      e.printInfo();
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    _jobTimer?.cancel();
  }

  Future<void> getPendingJobs({bool isLoader = true}) async {
    if (await _connectivityService.isConnected()) {
      try {
        var userId = sessionStorage.read(StorageKeys.userId);
        var request = MyJobRequest(
            userId: userId.toString(),
            bookingStatus: MyBookingStatus.pending.name);
        var jobData = await _myJobUseCase.execute(request);
        if (jobData?.data.isNotEmpty ?? false) {
          pendingJobs = true;
        } else {
          pendingJobs = false;
          Workmanager().cancelAll();
        }
      } catch (e) {
        e.printInfo();
      }
    }
  }

  getCity() async {
    homeStatus.value = HomeStatus.initiated;
    if (await _connectivityService.isConnected()) {
      try {
        final responds = await _homeUseCase.execute();

        cityInfo.value = responds.item1.data?.rows ?? [];
        activeBanners.value = responds.item2.data?.banners ?? [];
        midBanners.value = responds.item3.data ?? [];

        if (responds.item2.data?.pendingJobs != null &&
            responds.item2.data?.pendingJobs != 0) {
          pendingJobs = true;
        }
        if (responds.item2.data?.pendingPayments != null &&
            responds.item2.data?.pendingPayments != 0) {
          pendingPayments = true;
        }

        if (selectedCity.value.cityId != null &&
            selectedCity.value.cityId != 0 &&
            selectedCity.value.cityId.toString().isNotEmpty) {
          var services = await _cityServiceUseCase
              .execute(selectedCity.value.cityId.toString());
          cityServices.value = services?.data ?? [];
        } else if (cityInfo.value.isNotNullOrEmpty) {
          if (selectedCity.value.cityId == null ||
              selectedCity.value.cityId == 0) {
            await Get.bottomSheet(
              isDismissible: false,
              backgroundColor: Colors.white,
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              CityBottomSheet(
                city: cityInfo.value,
                height: cityInfo.value.length > 3
                    ? (cityInfo.value.length > 6 ? 800 : 500)
                    : 280,
                padding: const EdgeInsets.only(
                    top: 40, left: 12, right: 12, bottom: 5),
                onCitySelected: (city) {
                  Get.back();
                  onCitySelected(city);
                },
              ),
            );
          }
        }

        homeStatus.value = HomeStatus.loaded;
      } catch (e) {
        homeStatus.value = HomeStatus.loaded;
      }
    } else {
      showOpenSettings();
    }
  }

  void showCityPopup() async {
    if (cityInfo.value.isNotNullOrEmpty) {
      await Get.bottomSheet(
        isDismissible: false,
        backgroundColor: Colors.white,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        CityBottomSheet(
          city: cityInfo.value,
          height: cityInfo.value.length > 3
              ? (cityInfo.value.length > 6 ? 800 : 500)
              : 280,
          padding:
              const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 5),
          onCitySelected: (city) {
            Get.back();
            onCitySelected(city);
          },
        ),
      );
    } else {
      getCity();
    }
  }

  Future<void> onCitySelected(CityData city) async {
    selectedCity.value = city;
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        sessionStorage.write(StorageKeys.selectedCity, city.toJson());

        var services = await _cityServiceUseCase
            .execute(selectedCity.value.cityId.toString());
        cityServices.value = services?.data ?? [];
        hideLoadingDialog();
      } catch (e) {
        hideLoadingDialog();
        e.printInfo();
      }
    } else {
      showOpenSettings();
    }
  }

  Future<void> updatePushToken() async {
    if (await _connectivityService.isConnected()) {
      try {
        var userId = sessionStorage.read(StorageKeys.userId).toString();
        var userType = '';
        if (userId.isNotEmpty) {
          userType = 'user';
        } else {
          userType = '';
          userId = '';
        }

        var request = PushRequest(
          userId: userId.toString(),
          userType: userType,
          deviceToken: sessionStorage.read(StorageKeys.pushToken) ?? '',
        );
        await _pushTokenUseCase.execute(request);
      } catch (e) {
        e.printInfo();
      }
    }
  }

  Future<String> getAppInstanceId() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildSignature;
  }

  getReviews(String limit, String offset, String search, bool loadMore) async {
    if (await _connectivityService.isConnected()) {
      try {
        if (loadMore.absolute) {
          showLoadingDialog();
        }

        ReviewRequest request =
            ReviewRequest(limit: limit, offset: offset, search: search);
        ReviewListResponds? responds = await _reviewsUseCase.execute(request);

        if (responds?.success == true) {
          if (search == 'refresh') {
            reviewList.value = responds?.data?.rows ?? [];
          } else {
            reviewCount.value = responds?.data?.count ?? 0;
            var list = reviewList.value;
            list.addAll(responds?.data?.rows ?? []);
            reviewList.value = List<ReviewData>.from(list);
          }
        }
        if (loadMore.absolute) {
          hideLoadingDialog();
        }
      } catch (e) {
        if (loadMore.absolute) {
          hideLoadingDialog();
        }
        e.printInfo();
      }
    }
  }

  Future<void> _requestMultiplePermissions() async {
    // List of permissions to request
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();

    var isPermanentlyDenied =
        statuses.values.any((status) => status.isPermanentlyDenied);

    var isDenied = statuses.values.any((status) => status.isDenied);
    if (isPermanentlyDenied || isDenied) {
      _showPermissionDialogWithSettings(
        'Notification : Permissions Required',
        'Please allow the required permissions to continue using the app.',
      );
    }
  }

  void _showPermissionDialogWithSettings(String title, String message) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
              Get.back();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void startPendingJobTimer() {
    try {
      _jobTimer ??= Timer.periodic(
        const Duration(seconds: 15),
        (_) async {
          showPendingNotification();
        },
      );
    } catch (_) {}
  }
}
