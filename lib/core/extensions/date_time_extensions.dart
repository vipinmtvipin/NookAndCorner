import 'package:intl/intl.dart';

extension DateTimeUtil on DateTime? {
  String convertUtcToIst() {
    // Convert UTC to IST by adding 5 hours and 30 minutes
    DateTime istDateTime = this!.add(Duration(hours: 5, minutes: 30));

    // Format the IST DateTime to a string
    DateFormat dateFormat = DateFormat("dd, MMM yyyy hh:mm aa");
    String istDateString = dateFormat.format(istDateTime);

    return istDateString;
  }

  String formatDateTimeToISO() {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'");
    String formattedDate = dateFormat.format(this!.toUtc());
    return formattedDate;
  }

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
