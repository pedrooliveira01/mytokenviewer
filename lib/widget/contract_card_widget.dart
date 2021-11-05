import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytokenview/db/database.dart';

class ContractCardWidget extends StatelessWidget {
  ContractCardWidget({
    Key? key,
    required this.contract,
    required this.code,
    required this.index,
    required this.onAfterDelete,
  }) : super(key: key);

  final dynamic contract;
  final String code;
  final int index;
  final Function onAfterDelete;

  String getPriceFormat(dynamic price) {
    var decimals = 2;
    if (price < 0.001) {
      decimals = 5;
    } else if (price < 0.01) {
      decimals = 4;
    }
    return NumberFormat.simpleCurrency(decimalDigits: decimals).format(price);
  }

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        color: Colors.grey.shade600,
        alignment: Alignment.topRight,
        onPressed: () async {
          await TokenDB.instance.deleteCode(this.code);
          await onAfterDelete();
        },
      );

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = Colors.transparent;
    final double minHeight = 120;

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            SizedBox(height: 2),
            Row(
              children: [
                contract != null ? Image.network(contract['png32']) : Text(''),
                Spacer(),
                deleteButton()
              ],
            ),
            SizedBox(height: 2),
            Text(
              contract == null ? 'Error' : contract['name'],
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2),
            Text(
              contract == null ? 'Error' : getPriceFormat(contract['rate']),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
