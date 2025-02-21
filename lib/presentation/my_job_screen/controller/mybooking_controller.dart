import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/core/constants/constants.dart';
import 'package:customerapp/core/extensions/bool_extension.dart';
import 'package:customerapp/core/extensions/date_time_extensions.dart';
import 'package:customerapp/core/extensions/list_extensions.dart';
import 'package:customerapp/core/localization/localization_keys.dart';
import 'package:customerapp/core/network/connectivity_service.dart';
import 'package:customerapp/core/network/logging_interceptor.dart';
import 'package:customerapp/core/notifications/notification_msg_util.dart';
import 'package:customerapp/core/routes/app_routes.dart';
import 'package:customerapp/core/utils/common_util.dart';
import 'package:customerapp/domain/model/my_jobs/file_upload_request.dart';
import 'package:customerapp/domain/model/my_jobs/my_job_responds.dart';
import 'package:customerapp/domain/model/my_jobs/myjob_request.dart';
import 'package:customerapp/domain/model/my_jobs/update_addon_request.dart';
import 'package:customerapp/domain/model/service/time_slote_request.dart';
import 'package:customerapp/domain/model/service/time_slote_responds.dart';
import 'package:customerapp/domain/model/summery/addon_request.dart';
import 'package:customerapp/domain/model/summery/addon_service_responds.dart';
import 'package:customerapp/domain/model/summery/apply_cupon_responds.dart';
import 'package:customerapp/domain/model/summery/coupon_request.dart';
import 'package:customerapp/domain/model/summery/meta_responds.dart';
import 'package:customerapp/domain/usecases/my_job/add_coupon_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/cancel_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/file_upload_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/my_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/rating_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/reschedule_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/review_job_use_case.dart';
import 'package:customerapp/domain/usecases/my_job/update_addon_use_case.dart';
import 'package:customerapp/domain/usecases/service/service_slots_use_case.dart';
import 'package:customerapp/domain/usecases/summery/summery_use_case.dart';
import 'package:customerapp/presentation/base_controller.dart';
import 'package:customerapp/presentation/chat/chat_service.dart';
import 'package:customerapp/presentation/chat/message_data.dart';
import 'package:customerapp/presentation/main_screen/controller/main_controller.dart';
import 'package:customerapp/presentation/services_screen/controller/service_controller.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
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

  List<String> fileUrls = [];

  final FileUploadUseCase _fileUploadUseCase;
  final UpdateAddonUseCase _updateAddonUseCase;
  final AddCouponUseCase _applyCouponUseCase;

  MyBookingController(
    this._myJobUseCase,
    this._summeryUseCase,
    this._serviceSlotsUseCase,
    this._cancelJobUseCase,
    this._ratingJobUseCase,
    this._rescheduleJobUseCase,
    this._reviewJobUseCase,
    this._fileUploadUseCase,
    this._updateAddonUseCase,
    this._applyCouponUseCase,
  );

  var screenTitle = 'My Bookings'.obs;
  var screenType = MyBookingStatus.unknown;
  late final _connectivityService = getIt<ConnectivityService>();
  Rx<List<MyJobData>> jobList = Rx([]);
  Rx<MyJobData> selectedJob = Rx(MyJobData.empty());
  final sessionStorage = GetStorage();
  int calenderDayCount = 10;
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

  TextEditingController promoCodeController = TextEditingController();
  var couponApplied = false.obs;
  Rx<List<CouponData>> couponData = Rx([]);
  var selectedDateValue = 'Select Date'.obs;
  var selectedTime = ''.obs;
  Rx<List<TimeSlotData>> timeSlots = Rx([]);
  var serviceStatus = ServiceStatus.unknown.obs;

  var jobApiStarted = true;

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

  @override
  void onClose() {
    super.onClose();
    promoCodeController.clear();
  }

  Future<void> getJobs({bool isLoader = true}) async {
    if (await _connectivityService.isConnected()) {
      try {
        if (isLoader) {
          showLoadingDialog();
        }
        var userId = sessionStorage.read(StorageKeys.userId);
        var request = MyJobRequest(
            userId: userId.toString(), bookingStatus: screenType.name);
        var jobData = await _myJobUseCase.execute(request);
        jobList.value = jobData?.data ?? [];

        if (request.bookingStatus == MyBookingStatus.pending.name &&
            jobList.value.isNotEmpty) {
          try {
            if (jobList.value.isNotNullOrEmpty) {
              Get.find<MainScreenController>().pendingJobs = true;
            } else {
              Get.find<MainScreenController>().pendingJobs = false;
            }
          } catch (_) {}
          await NotificationMsgUtil.scheduleRepeatingNotification();
        } else {
          Get.find<MainScreenController>().pendingJobs = false;
          NotificationMsgUtil.cancelPeriodicNotification();
        }

        if (isLoader) {
          hideLoadingDialog();
        }
      } catch (e) {
        if (isLoader) {
          hideLoadingDialog();
        }

        if (jobApiStarted.absolute) {
          getJobs(isLoader: isLoader);
          jobApiStarted = false;
        }
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

        calenderDayCount =
            int.tryParse(metaData.value.calendarDays ?? '10') ?? 10;
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
      jobDate:
          '${DateFormat('yyyy-MM-dd').format(selectedDate.value)} 00:00:00.000+0530',
      serviceId: service.serviceId.toString(),
    );

    getTimeSlots(request);
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

  Future<void> completeJob(String from) async {
    var paymentAmount = double.parse(
        (selectedJob.value.price! - selectedJob.value.advanceAmount!)
            .toStringAsFixed(2));

    if (couponApplied.value.absolute && couponData.value.isNotNullOrEmpty) {
      if (couponData.value.first.promotionType == 'percent') {
        double servicePercentage = paymentAmount / 100;
        var couponPercentage = couponData.value.first.discountOfferPrice ?? 0.0;
        var couponAmount = servicePercentage * couponPercentage;
        couponAmount = double.parse(couponAmount.toStringAsFixed(2));
        paymentAmount = couponAmount;
      } else if (couponData.value.first.promotionType == 'free') {
        paymentAmount = 0.0;
      } else {
        var couponAmount = couponData.value.first.discountOfferPrice ?? 0.0;
        paymentAmount = paymentAmount - couponAmount;
      }
    }

    paymentAmount = double.parse(paymentAmount.toStringAsFixed(2));

    couponApplied.value = false;
    couponData.value = [];

    await Get.toNamed(AppRoutes.paymentScreen, arguments: {
      'orderID': selectedJob.value.txnId,
      'paymentAmount': paymentAmount,
      'paymentType': "Complete",
    });

    jobApiStarted = true;

    if (from == 'list') {
      getJobs(isLoader: false);
    } else {
      Get.back();
      getJobs(isLoader: false);
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
          Get.back(result: true);
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

  Future<void> updateAddOn() async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        List<AddOnData> updateAddOns = [];
        for (var addon in addOns.value) {
          var originalAddOn = AddOnData.empty();
          for (var addonItem in addOnList.value) {
            if (addonItem.addonId == addon.addonId) {
              originalAddOn = addonItem;
              break;
            }
          }

          updateAddOns.add(AddOnData(
            addonId: originalAddOn.addonId,
            price: originalAddOn.price,
            quantity: addon.quantity,
            titile: originalAddOn.titile,
            updatedAt: originalAddOn.updatedAt,
            createdAt: originalAddOn.createdAt,
            delete: originalAddOn.delete,
            status: originalAddOn.status,
            logo: originalAddOn.logo,
            description: originalAddOn.description,
            addonService: originalAddOn.addonService,
          ));
        }

        var request = UpdateAddonRequest(
          jobId: selectedJob.value.jobId.toString(),
          addons: updateAddOns,
          convenienceFee: convenienceFee.value.toString(),
          grandTotal: grandTotal.value.toString(),
          serviceId: selectedJob.value.serviceId.toString(),
        );
        var services = await _updateAddonUseCase.execute(request);

        if (services?.success == true) {
          showToast('Add-On Updated');
          Get.back(result: true);
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
          userId: sessionStorage.read(StorageKeys.userId).toString(),
        );

        showLoadingDialog();
        var services = await _reviewJobUseCase.execute(request);

        if (services?.success == true) {
          showToast('Your review recorded!');
          getJobs();
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
          userId: sessionStorage.read(StorageKeys.userId).toString(),
        );

        showLoadingDialog();
        var services = await _ratingJobUseCase.execute(request);

        if (services?.success == true) {
          showToast('Your rating recorded!');
          jobApiStarted = true;
          getJobs();
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

        var isGoldenHour = isAfter6PM(selectedTimeSlot.slotStart);

        ReScheduleJobRequest request = ReScheduleJobRequest(
          goldenHourAdded: isGoldenHour,
          supervisors: selectedTimeSlot.supervisors ?? [],
          jobId: selectedJob.value.jobId.toString(),
          jobDate: GetIt.I<CommonUtil>()
              .parseJobDate(
                DateFormat('yyyy-MM-dd').format(selectedDate.value),
                selectedTime.value,
              )
              .formatDateTimeToISO(),
        );

        showLoadingDialog();

        var services = await _rescheduleJobUseCase.execute(request);

        if (services?.success == true) {
          showToast('Job Rescheduled Successfully');
          Get.back(result: true);
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

  Future<void> applyCoupon(String code, String from) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        CouponRequest request = CouponRequest(
          slot: selectedDate.value.toString(),
          promotionName: code,
          serviceId: selectedJob.value.serviceId.toString(),
          type: 'final',
        );

        var coupon = await _applyCouponUseCase.execute(request);
        if (coupon?.data.isNotEmpty ?? false) {
          couponData.value = coupon?.data ?? [];
          couponApplied.value = true;

          showToast(coupon?.message ?? 'Promo code applied successfully');
          promoCodeController.clear();
          hideLoadingDialog();
          completeJob(from);
        } else {
          hideLoadingDialog();
          couponApplied.value = false;
        }
      } catch (e) {
        couponApplied.value = false;
        hideLoadingDialog();
        showSnackBar("Error", e.toString(), Colors.black);
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
        convenienceFees =
            convenienceFees + double.parse(convenienceValue.toStringAsFixed(2));
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
      convenienceFees =
          convenienceFees + double.parse(convenienceValue.toStringAsFixed(2));
    }
    addOnsTotal.value = 0;
    addOnsTotal.value = price;
    convenienceFee.value = 0;
    convenienceFee.value = convenienceFees;
    calculateGrandTotal();
  }

  Future<void> uploadFile(
      List<PlatformFile> files, String adminMessage, String userName) async {
    if (await _connectivityService.isConnected()) {
      try {
        showLoadingDialog();

        List<FileUploadRequest> request = [];

        for (var file in files) {
          var fileType = 'image';
          if (file.path!.contains('jpg') ||
              file.path!.contains('jpeg') ||
              file.path!.contains('png')) {
            fileType = 'image';
          } else {
            fileType = 'video';
          }
          request.add(FileUploadRequest(
            fileName: file.path?.split('/').last,
            fileType: fileType,
          ));
        }

        var services = await _fileUploadUseCase.execute(request);

        if (services?.success == true) {
          for (int i = 0; i < files.length; i++) {
            final fileData = File(files[i].path!);

            bool singleItem = true;
            bool lastItem = false;
            if (files.length > 1) {
              singleItem = false;
            }
            if (i == files.length - 1) {
              lastItem = true;
            }

            fileUrls.add(services?.data?.urls[i].filePath ?? '');

            _uploadToAws(
                services?.data?.urls[i].preSignedUrl ?? '',
                services?.data?.urls[i].filePath ?? '',
                fileData,
                adminMessage,
                userName,
                singleItem,
                lastItem);
          }
        } else {
          hideLoadingDialog();
          showToast('File Uploaded failed');
        }
      } catch (e) {
        hideLoadingDialog();
        showToast('File Uploaded failed');
        e.printInfo();
      }
    } else {
      showToast(LocalizationKeys.noNetwork.tr);
    }
  }

  Future<void> _uploadToAws(
    String preSignedUrl,
    String imageUrl,
    File file,
    String adminMessage,
    String name,
    bool singleItem,
    bool lastItem,
  ) async {
    try {
      final Dio dio = Dio(BaseOptions(
        baseUrl: NetworkKeys.baseUrl,
        connectTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
      ))
        ..interceptors.addAll([
          LoggingInterceptor(
            requestBody: true,
            requestHeader: true,
            request: true,
            responseBody: true,
          ),
        ])
        ..transformer = BackgroundTransformer();

      // Determine the Content-Type based on file extension
      String contentType = '';
      final fileExtension = file.path.split('.').last.toLowerCase();
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
        case 'pdf':
          contentType = 'application/pdf';
          break;
        case 'mp4':
          contentType = 'video/mp4';
          break;
        case 'mov':
          contentType = 'video/mov';
          break;
        case 'avi':
          contentType = 'video/avi';
          break;
        case '3gp':
          contentType = 'video/3gp';
          break;
        default:
          contentType =
              'application/octet-stream'; // Fallback for unknown types
      }

      // Init the request
      final response = await dio.put(
        preSignedUrl,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: file.lengthSync(),
            Headers.contentTypeHeader: contentType,
          },
        ),
      );

      if (response.statusCode == 200) {
        if (singleItem) {
          sendFileToFirebase(
            selectedJob.value.userId.toString(),
            selectedJob.value.jobId.toString(),
            adminMessage,
            name,
          );
        } else if (lastItem) {
          sendFileToFirebase(
            selectedJob.value.userId.toString(),
            selectedJob.value.jobId.toString(),
            adminMessage,
            name,
          );
        }
      } else {
        showToast('File Uploaded failed');
      }
    } catch (e) {
      showToast('File Uploaded failed');
    } finally {
      hideLoadingDialog();
    }
  }

  void sendFileToFirebase(
    String userId,
    String jobId,
    String adminMessage,
    String name,
  ) {
    final ChatService chatService = GetIt.I<ChatService>();
    final message = Message(
      from: 'user',
      message: '',
      timestamp: Timestamp.now(),
      userId: sessionStorage.read(StorageKeys.userId).toString(),
      fileUrl: fileUrls,
      name: name,
    );
    chatService.sendMessage(
      userId,
      jobId,
      message,
    );

    final messageAdmin = Message(
      from: 'admin',
      message: adminMessage,
      timestamp: Timestamp.now(),
      userId: userId,
      fileUrl: [],
      name: "Admin",
    );
    chatService.sendMessage(
      userId,
      jobId,
      messageAdmin,
    );

    fileUrls.clear();
    fileUrls = [];
  }
}
