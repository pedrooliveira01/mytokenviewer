import 'package:intl/intl.dart';

String getDateTimeStrFromTimeStampo(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('dd/MM/yyyy – kk:mm').format(date);
}

String getHourFromTimeStampo(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('kk:mm').format(date);
}

DateTime getDateTimeFromTimeStampo(int timestamp) {
  return new DateTime.fromMillisecondsSinceEpoch(timestamp);
}
