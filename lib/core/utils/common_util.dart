import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonUtil {
  void keyboardHide(BuildContext context) {
    try {
      FocusScope.of(context)
          .requestFocus(FocusNode()); // not refocus to textview
    } catch (e) {
      e.printError();
    }
  }

  double? toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String currentDate(String from) {
    var now = DateTime.now();
    String date;
    if (from == "revers") {
      date = DateFormat("yyyy-MM-dd").format(now);
    } else {
      date = DateFormat("dd-MM-yyyy").format(now);
    }
    return date.toString();
  }

  String currentTime() {
    var now = DateTime.now();
    var time = DateFormat("H:m:s").format(now);
    return time.toString();
  }

  String currentDateTimeMilli() {
    var now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  String currentDateTime() {
    var now = DateTime.now();
    var time = DateFormat("dd-MM-yyyy hh:mm:ss").format(now);
    return time.toString();
  }

  String dateFormat(String data) {
    try {
      DateTime parseDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(data);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd MMM yyyy');
      var outputDate = outputFormat.format(inputDate);

      return outputDate.toString();
    } catch (e) {
      return data;
    }
  }

  String dateFormatTime(String data) {
    try {
      DateTime parseDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(data);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('hh:mm a');
      var outputDate = outputFormat.format(inputDate);

      return outputDate.toString();
    } catch (e) {
      return data;
    }
  }
}
