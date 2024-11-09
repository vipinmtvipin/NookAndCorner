/*
 * Copyright (c) 2024, Vipin.
 */

/// Constants for Rest Api's
class NetworkKeys {
  NetworkKeys._();

  static const String baseUrl = staging;

  static const String staging = 'https://staging-api.nookandcorner.org/api/v1';
  static const String production = 'https://api.nookandcorner.org';

  static const String loginMobile = '/auth/verify-phone';
  static const String loginEmail = '/auth/verify-email';
  static const String login = '/auth/login';

  static const String signupMobile = '/auth/register/phone';
  static const String signupEmail = '/auth/register/email';
  static const String signup = '/auth/register/verify-otp';

  static const String forgetPassword = '/auth/forgot-password';

  static const String city = '/cities';
  static const String cityService = '/customer-category/city';
  static const String midBanner = '/mid-banner/ban/active';
  static const String activeBanner = '/banner/ban/active';

  static const String timeSlot = '/job/time/slot';
  static const String serviceDetails = '/customer-service/cat';
  static const String serviceTag = '/category-tag/category';
  static const String serviceTagItems = '/service/tags';
  static const String getAddress = '/';
  static const String saveAddress = '/';

  static const String applyCoupon = '/promotion/validate';
  static const String metaData = '/meta-values';
  static const String createJobLogin = '/job/V1/login';
  static const String createJob = '/job/V1';
  static const String addOns = '/addons';

  static const String cancelledJob = '/job/cancelled';
  static const String completedJob = '/job/completed';
  static const String pendingJob = '/job/pending';
  static const String scheduledJob = '/job/scheduled';
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
}
