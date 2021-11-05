import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mytokenview/db/database.dart';
import 'package:mytokenview/model/contracts.dart';
import 'package:mytokenview/page/edit_contract_page.dart';
import 'package:mytokenview/page/contract_detail_page.dart';
import 'package:mytokenview/widget/contract_card_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContractsPage extends StatefulWidget {
  @override
  _ContractsPageState createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  late List<dynamic> contractsFetch = [];
  late List<Contract> contractsList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshContracts();
  }

  @override
  void dispose() {
    TokenDB.instance.close();

    super.dispose();
  }

  Future refreshContracts() async {
    if (isLoading) {
      return;
    }
    setState(() => isLoading = true);

    contractsList = await TokenDB.instance.readAllContracts();
    this.contractsFetch.clear();

    for (var contract in contractsList) {
      if (contract.code.length > 2) {
        //var url =
        //    Uri.parse('https://api.pancakeswap.info/api/v2/tokens/${value}');
        var url = Uri.parse('https://api.livecoinwatch.com/coins/single');

        var requestBody = jsonEncode(<String, String>{
          'currency': 'USD',
          'code': '${contract.code.toUpperCase()}',
          'meta': 'true'
        });
        var request = await http.post(url,
            headers: {
              'content-type': 'application/json',
              'x-api-key': '26d5c603-6332-4c9f-aaf4-6f54abe71f86'
            },
            body: requestBody);
        this.contractsFetch.add(json.decode(request.body));
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'My tokens viewer',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                refreshContracts();
              },
            )
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : contractsFetch.isEmpty
                  ? Text(
                      'Sem tokens',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildContracts(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditContractPage()),
            );

            refreshContracts();
          },
        ),
      );

  Widget buildContracts() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: contractsFetch.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final contract = contractsFetch[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContractDetailPage(
                    code: contractsList.elementAt(index).code),
              ));

              refreshContracts();
            },
            child: ContractCardWidget(
                contract: contract,
                index: index,
                code: contractsList.elementAt(index).code,
                onAfterDelete: refreshContracts),
          );
        },
      );
}
