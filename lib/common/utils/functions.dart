import 'package:intl/intl.dart';

String toTitleCase(String text) {
  if (text.isEmpty) {
    return text;
  }

  return text.split(" ").map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(" ");
}

String getDateTimeNow() {
  DateTime now = DateTime.now();

  String formattedDate = DateFormat("dd/MM/yyyy - HH:mm:ss").format(now);
  return formattedDate;
}
