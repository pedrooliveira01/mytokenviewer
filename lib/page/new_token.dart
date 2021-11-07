import 'package:flutter/material.dart';
import 'package:mytokenview/api/tokens.dart';
import 'package:mytokenview/db/database.dart';
import 'package:mytokenview/model/coin.dart';
import 'package:mytokenview/model/contracts.dart';
import 'package:mytokenview/widget/add_edit_token_form.dart';

class AddEditContractPage extends StatefulWidget {
  final Contract? contract;
  final String apiKey;

  const AddEditContractPage({
    Key? key,
    this.contract,
    required this.apiKey,
  }) : super(key: key);
  @override
  _AddEditContractPageState createState() => _AddEditContractPageState();
}

class _AddEditContractPageState extends State<AddEditContractPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String img;
  late String code;
  late String decimals;

  @override
  void initState() {
    super.initState();

    code = widget.contract?.code ?? '';
    name = widget.contract?.name ?? '';
    img = widget.contract?.img ?? '';
    decimals = widget.contract?.decimals != null
        ? '${widget.contract?.decimals}'
        : '2';
  }

  Future setAddress(String value) async {
    setState(() => this.code = value);
    setState(() => this.name = '');
    setState(() => this.img = '');
    setState(() => this.decimals = '2');

    if (await TokenDB.instance.existToken(value)) {
      setState(() => this.name = 'Token already exists');
      return;
    }

    if (value.length > 2) {
      var response = await getToken(value.toUpperCase(), widget.apiKey);
      if (response['error'] == null) {
        Coin coin = Coin.fromJson(response);
        setState(() => this.name = coin.name);
        setState(() => this.img = coin.png32);
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
            code: code,
            name: name,
            img: img,
            decimals: decimals,
            isNew: widget.contract == null,
            onChangedAddress: (address) => setAddress(address),
            onChangedDecimals: (decimals) =>
                setState(() => this.decimals = decimals),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = name.isNotEmpty &&
        img.isNotEmpty &&
        code.isNotEmpty &&
        decimals.isNotEmpty &&
        int.parse(decimals) > 0;

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
      widget.contract != null ? await updateContract() : await addContract();
      Navigator.of(context).pop();
    }
  }

  Future updateContract() async {
    final contract = widget.contract!.copy(
        code: code,
        name: name,
        address: '-',
        img: img,
        decimals: int.parse(decimals));

    await TokenDB.instance.update(contract);
  }

  Future addContract() async {
    final contract = Contract(
        code: code,
        name: name,
        address: '-',
        img: img,
        decimals: int.parse(decimals));

    await TokenDB.instance.create(contract);
  }
}
