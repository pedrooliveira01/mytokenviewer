import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mytokenview/utils/price_format.dart';

class Calculator extends StatefulWidget {
  final int? decimals;
  final double price;

  const Calculator({
    Key? key,
    this.decimals,
    required this.price,
  }) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  double theResult = 0, value = 0;

  void calculate(String value) {
    double doubleValue = value.isNotEmpty ? double.parse(value) : 0;
    setState(() {
      theResult = doubleValue * widget.price;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        buildValueInput(calculate),
        buildValueResult(theResult, widget.decimals)
      ],
    ));
  }
}

Widget buildValueInput(ValueChanged<String> onChange) {
  return SizedBox(
      width: 150,
      child: TextFormField(
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Value',
          hintStyle: TextStyle(color: Colors.white70),
          labelStyle: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: onChange,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
      ));
}

Widget buildValueResult(double value, int? decimals) {
  return SizedBox(
      width: 150,
      child: Text(
        ' ${getPriceFormat(value, decimals)}',
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ));
}


/*,
      )*/