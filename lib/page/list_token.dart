import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mytokenview/api/tokens.dart';
import 'package:mytokenview/db/database.dart';
import 'package:mytokenview/model/contracts.dart';
import 'package:mytokenview/page/new_token.dart';
import 'package:mytokenview/page/detail_token.dart';
import 'package:mytokenview/widget/card.dart';

class ContractsPage extends StatefulWidget {
  @override
  _ContractsPageState createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  late List<dynamic> contractsFetch = [];
  late List<Contract> contractsList = [];
  late String apiKey = '';
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
    this.contractsList.clear();
    this.contractsList = await TokenDB.instance.readAllContracts();
    if (apiKey == '') {
      this.apiKey = await getApiToken();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'My tokens viewer',
            style: TextStyle(fontSize: 20),
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
              : contractsList.isEmpty
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
              MaterialPageRoute(
                  builder: (context) =>
                      AddEditContractPage(apiKey: this.apiKey)),
            );

            refreshContracts();
          },
        ),
      );

  Widget buildContracts() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: contractsList.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContractDetailPage(
                    code: contractsList.elementAt(index).code,
                    apiKey: this.apiKey),
              ));
              refreshContracts();
            },
            child: ContractCardWidget(contractsList.elementAt(index).code,
                contractsList.elementAt(index).decimals, this.apiKey),
          );
        },
      );
}
