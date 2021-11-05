import 'package:flutter/material.dart';

class ContractFormWidget extends StatelessWidget {
  final String name;
  final String img;
  final String code;
  final ValueChanged<String> onChangedAddress;

  const ContractFormWidget({
    Key? key,
    this.name = '',
    this.img = '',
    this.code = '',
    required this.onChangedAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildCode(),
              SizedBox(height: 16),
              buildImg(),
              SizedBox(height: 10),
              buildName(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildCode() => TextFormField(
        maxLines: 2,
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
