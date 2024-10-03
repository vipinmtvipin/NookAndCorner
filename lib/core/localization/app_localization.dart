import 'package:get/get.dart';
import 'ar_AR/ar_translations.dart';
import 'en_us/en_us_translations.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUs,  'ar_AR' : arAR};
}
