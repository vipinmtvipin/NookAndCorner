/*
 * Copyright (c) 2024, Vipin.
 */

/// Constants for Rest Api's
class NetworkKeys {
  NetworkKeys._();

  /// BASE URL
  static const String baseUrl = staging;

  static const String staging = 'https://staging-api.nookandcorner.org/api/v1';
  static const String production = 'https://api.nookandcorner.org/api/v1';

  /// FIREBASE
  static const String firebaseNode = firebaseNodeStaging;

  static const String firebaseNodeStaging = 'chat-stag';
  static const String firebaseNodeProduction = 'chat';

  /// PAYMENT GATEWAY
  /// Staging
  static const String ccAvenueUrl = ccAvenueUrlStaging;
  static const String ccaCallbackUrl = ccaCallbackUrlStaging;
  static const String ccaAdvCallbackUrl = ccaAdvCallbackUrlStaging;
  static const String ccAvenueCancelUrl = ccAvenueCancelUrlStaging;
  static const String ccaMerchantId = ccaMerchantIdStaging;
  static const String ccaAccessCode = ccaAccessCodeStaging;
  static const String ccaWorkingKey = ccaWorkingKeyStaging;

  /// Production
/*  static const String ccAvenueUrl = ccAvenueUrlProd;
  static const String ccaCallbackUrl = ccaCallbackUrlProd;
  static const String ccaAdvCallbackUrl = ccaAdvCallbackUrlProd;
  static const String ccAvenueCancelUrl = ccAvenueCancelUrlProd;
  static const String ccaMerchantId = ccaMerchantIdProd;
  static const String ccaAccessCode = ccaAccessCodeProd;
  static const String ccaWorkingKey = ccaWorkingKeyProd;*/

  static const String ccaMerchantIdStaging = "2115707";
  static const String ccaAccessCodeStaging = "ATSZ24KB14BV64ZSVB";
  static const String ccaWorkingKeyStaging = "E251D59D0357F3AF1295B0B9D4E84776";

  static const String ccaMerchantIdProd = "2115707";
  static const String ccaAccessCodeProd = "AVSZ24KB14BV64ZSVB";
  static const String ccaWorkingKeyProd = "E251D59D0357F3AF1295B0B9D4E84776";

  static const String ccAvenueUrlStaging =
      "https://test.ccavenue.com/transaction/transaction.do?command=initiateTransaction";
  static const String ccaCallbackUrlStaging =
      "https://staging-api.nookandcorner.org/api/v1/payu-payment/success";
  static const String ccaAdvCallbackUrlStaging =
      "https://staging-api.nookandcorner.org/api/v1/payu-payment/advance-payment/success";
  static const String ccAvenueCancelUrlStaging =
      "https://staging-api.nookandcorner.org/api/v1/payu-payment/cancel";

  static const String ccAvenueUrlProd =
      "https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction";
  static const String ccaCallbackUrlProd =
      "https://api.nookandcorner.org/api/v1/payu-payment/success";
  static const String ccaAdvCallbackUrlProd =
      "https://api.nookandcorner.org/api/v1/payu-payment/advance-payment/success";
  static const String ccAvenueCancelUrlProd =
      "https://api.nookandcorner.org/api/v1/payu-payment/cancel";

  static const String loginMobile = '/auth/verify-phone';
  static const String loginEmail = '/auth/verify-email';
  static const String login = '/auth/login';

  static const String signupMobile = '/auth/register/phone';
  static const String signupEmail = '/auth/register/email';
  static const String signup = '/auth/register/verify-otp';

  static const String jobOtpVerify = '/auth/register/job/verify-otp';

  static const String accountVerification = '/auth/profile/update';
  static const String accountEmailMobileVerification =
      '/auth/profile/verify-otp';

  static const String forgetPassword = '/auth/forgot-password';

  static const String city = '/cities';

  static const String pushToken = '/fcm/device-token';
  static const String cityService = '/customer-category/city';
  static const String midBanner = '/mid-banner/ban/active';
  static const String activeBanner = '/banner/ban/active';

  static const String timeSlot = '/job/time/slot';
  static const String serviceDetails = '/customer-service/cat';
  static const String serviceTag = '/category-tag/category';
  static const String serviceTagItems = '/service/tags';
  static const String getAddress = '/address/address';
  static const String saveAddress = '/address';

  static const String user = '/users';

  static const String confirmAddress = '/job/confirm';
  static const String deleteAddress = '/address/delete';
  static const String primaryAddress = '/address/primary';
  static const String updateAddon = '/job/update-addon';

  static const String fileUpload = '/firebase-chat/presigned-url';
  static const String applyCoupon = '/promotion/validate';
  static const String metaData = '/meta-values';
  static const String createJobLogin = '/job/V1/login';
  static const String createJob = '/job/V1';
  static const String addOns = '/addons';

  static const String cancelledJob = '/job/cancelled';
  static const String completedJob = '/job/completed';
  static const String pendingJob = '/job/pending';
  static const String scheduledJob = '/job/scheduled';

  static const String reSchedule = '/job/update/re-schedule';
  static const String cancelJob = '/job/cancel';

  static const String contact = '/contact';

  static const String reviews = '/rating/approved';
  static const String rating = '/rating';
  static const String comment = '/rating/comment';
}

/// Constants for Session storage
class StorageKeys {
  StorageKeys._();

  static const String token = 'token';
  static const String pushToken = 'push_token';
  static const String loggedIn = 'loggedIn';
  static const String firstLogin = 'firstLogin';
  static const String username = 'username';
  static const String userId = 'userId';
  static const String email = 'email';
  static const String mobile = 'mobile';
  static const String address = 'address';
  static const String selectedCity = 'city';
  static const String from = 'from';
}
