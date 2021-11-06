import 'package:intl/intl.dart';

String getPriceFormat(dynamic price, int? decimals) {
  return NumberFormat.simpleCurrency(
          decimalDigits: decimals != null ? decimals : 2)
      .format(price);
}
