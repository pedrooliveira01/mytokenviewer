import 'package:flutter/material.dart';

class ContractFormWidget extends StatelessWidget {
  final String name;
  final String img;
  final String code;
  final String decimals;
  final bool isNew;
  final ValueChanged<String> onChangedAddress;
  final ValueChanged<String> onChangedDecimals;

  const ContractFormWidget({
    Key? key,
    this.code = '',
    this.name = '',
    this.img = '',
    this.decimals = '2',
    this.isNew = true,
    required this.onChangedAddress,
    required this.onChangedDecimals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildCode(),
              SizedBox(height: 8),
              buildDecimals(),
              SizedBox(height: 8),
              buildImg(),
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
            ],
          ),
        ),
      );

  Widget buildCode() => isNew
      ? TextFormField(
          maxLines: 1,
          initialValue: code,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Enter code token (ex: BNB)',
            hintStyle: TextStyle(color: Colors.white70),
            labelStyle: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          validator: (title) =>
              title != null && title.isEmpty ? 'Need a code token' : null,
          onChanged: onChangedAddress,
        )
      : SizedBox(height: 0);

  Widget buildDecimals() => TextFormField(
        keyboardType: TextInputType.number,
        maxLines: 1,
        maxLength: 1,
        initialValue: decimals,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter number of decimals (max 9)',
          hintStyle: TextStyle(color: Colors.white70),
          labelStyle: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty || int.parse(value) <= 0
                ? 'Need a decimal number'
                : null,
        onChanged: onChangedDecimals,
      );

  Widget buildName() => Text(
        'Token: $name',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget buildImg() => img != '' ? Image.network(img) : Text('');
}
