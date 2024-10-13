import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

extension StringUtil on String? {
  DateTime get convertStringToDateTime =>
      DateTime.tryParse(this ?? '') ?? DateTime.now();

  double get toDecimal => double.tryParse(this ?? '0.0') ?? 0.0;

  int get toInt => int.tryParse(this ?? '0') ?? 0;

  String get toCapitalized {
    return isNullOrEmpty
        ? ''
        : '${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}';
  }

  DateTime get to24Time => DateFormat('HH:mm', 'en').parse(this!);

  List<String> get splitBySpaceAndComma {
    final result = <String>[];
    final data = this?.trim();

    if (data?.isNotEmpty ?? false) {
      // Use regular expression to split by both space and comma
      result.addAll(
          data!.split(RegExp(r'[ ,]+')).where((element) => element.isNotEmpty));
    }

    return result;
  }

  showToast(ToastGravity? gravity) {
    Fluttertoast.showToast(
        msg: this!,
        gravity: gravity ?? ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2);
  }

  String formatAsDate(String format, {String? fromFormat}) {
    final data = this?.trim();

    if (data.isNullOrEmpty) {
      return '';
    }
    DateTime parsedDate;
    if (fromFormat.isNotNullOrEmpty) {
      parsedDate = DateFormat(fromFormat).parse(this!);
    } else {
      parsedDate = DateTime.parse(this!);
    }
    String formattedDate = DateFormat(format).format(parsedDate);

    return formattedDate;
  }
}

extension StringValidation on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String get removeSpaces => this?.replaceAll(' ', '').toUpperCase() ?? '';

  bool notContains(String value) => !(this?.contains(value) ?? false);
}
