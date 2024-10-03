import 'package:intl/intl.dart';

extension DateTimeUtil on DateTime? {
  String format({
    String format = 'yyyy-MM-dd',
  }) {
    return DateFormat(format, 'en').format(this!);
  }

  String get to12Hour => DateFormat('hh:mm', 'en').format(this!);

  String get timePeriod => DateFormat('a', 'en').format(this!);

  String get dayOfWeekShort => DateFormat('EE', 'en').format(this!);

  String get todayDate => DateFormat('yyyy-MM-dd', 'en').format(this!);
}
