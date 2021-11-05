import 'package:flutter/material.dart';
import 'package:mytokenview/db/database.dart';
import 'package:mytokenview/model/contracts.dart';
import 'package:mytokenview/widget/contract_form_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEditContractPage extends StatefulWidget {
  final Contract? contract;

  const AddEditContractPage({
    Key? key,
    this.contract,
  }) : super(key: key);
  @override
  _AddEditContractPageState createState() => _AddEditContractPageState();
}

class _AddEditContractPageState extends State<AddEditContractPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String img;
  late String code;

  @override
  void initState() {
    super.initState();

    name = widget.contract?.name ?? '';
    img = widget.contract?.img ?? '';
    code = widget.contract?.code ?? '';
  }

  Future setAddress(String value) async {
    setState(() => this.code = value);
    setState(() => this.name = '');
    setState(() => this.img = '');

    if (value.length > 2) {
      //var url =
      //    Uri.parse('https://api.pancakeswap.info/api/v2/tokens/${value}');
      var url = Uri.parse('https://api.livecoinwatch.com/coins/single');

      var requestBody = jsonEncode(<dynamic, dynamic>{
        'currency': 'USD',
        'code': '${value.toUpperCase()}',
        'meta': true
      });

      var request = await http.post(url,
          headers: {
            'content-type': 'application/json',
            'x-api-key': '26d5c603-6332-4c9f-aaf4-6f54abe71f86'
          },
          body: requestBody);
      var contractFetch = json.decode(request.body);

      if (contractFetch != null && contractFetch['error'] == null) {
        setState(() => this.name = contractFetch['name']);
        setState(() => this.img = contractFetch['png32']);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: ContractFormWidget(
            name: name,
            img: img,
            code: code,
            onChangedAddress: (address) => setAddress(address),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = name.isNotEmpty && img.isNotEmpty && code.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: () => addOrUpdateContract(isFormValid),
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateContract(bool isFormValid) async {
    final isValid = _formKey.currentState!.validate() && isFormValid;

    if (isValid) {
      final isUpdating = widget.contract != null;

      if (isUpdating) {
        await updateContract();
      } else {
        await addContract();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateContract() async {
    final contract = widget.contract!.copy(
      code: code,
      name: name,
      address: '-',
      img: img,
    );

    await TokenDB.instance.update(contract);
  }

  Future addContract() async {
    final contract = Contract(
      code: code,
      name: name,
      address: '-',
      img: img,
    );

    await TokenDB.instance.create(contract);
  }
}
