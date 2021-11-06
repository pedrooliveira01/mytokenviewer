import 'package:intl/intl.dart';

String getDateTimeFromTimeStampo(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('dd/MM/yyyy – kk:mm').format(date);
}
