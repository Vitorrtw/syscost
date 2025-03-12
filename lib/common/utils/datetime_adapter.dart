import 'package:intl/intl.dart';

class DateTimeAdapter {
  String getDateNow() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  String getDateTimeNowBR() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy - HH:mm:ss');
    return formatter.format(now);
  }

  String getDateNowBR() {
    final now = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  String formatDate(String date) {
    final formatter = DateFormat('yyyy-MM-dd');
    final dateTime = DateTime.parse(date);
    return formatter.format(dateTime);
  }

  String formatDateToBR(String date) {
    final formatter = DateFormat('dd/MM/yyyy');
    final dateTime = DateTime.parse(date);
    return formatter.format(dateTime);
  }

  DateTime formatDateToDateTime(String date) {
    final formatter = DateFormat('yyyy-MM-dd');
    final dateTime = formatter.parse(date);
    return dateTime;
  }

  DateTime formatDateBRtoDateTime(String date) {
    final formatter = DateFormat('dd/MM/yyyy');
    final dateTime = formatter.parse(date);
    return dateTime;
  }

  String formatDateEndTimeToBR(String dateTime) {
    final dateTimeObj = DateTime.parse(dateTime);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTimeObj);
  }

  String calculateAge(String date) {
    final formatter = DateFormat('yyyy-MM-dd');
    final birthDate = formatter.parse(date);
    final now = DateTime.now();

    var age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age.toString();
  }
}
