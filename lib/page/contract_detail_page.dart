import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytokenview/db/database.dart';
import 'package:mytokenview/model/contracts.dart';
import 'package:mytokenview/page/edit_contract_page.dart';

class ContractDetailPage extends StatefulWidget {
  final String code;

  const ContractDetailPage({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  _ContractDetailPageState createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  late Contract contract;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshContract();
  }

  Future refreshContract() async {
    setState(() => isLoading = true);

    this.contract = await TokenDB.instance.readContractCode(widget.code);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      contract.code,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      contract.name,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    contract.img != '' ? Image.network(contract.img) : Text('')
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditContractPage(contract: contract),
        ));

        refreshContract();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await TokenDB.instance.deleteCode(widget.code);

          Navigator.of(context).pop();
        },
      );
}
