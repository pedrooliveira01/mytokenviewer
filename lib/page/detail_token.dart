import 'package:flutter/material.dart';
import 'package:mytokenview/api/tokens.dart';
import 'package:mytokenview/db/database.dart';
import 'package:mytokenview/model/coin.dart';
import 'package:mytokenview/model/contracts.dart';
import 'package:mytokenview/page/new_token.dart';
import 'package:mytokenview/utils/price_format.dart';
import 'package:mytokenview/widget/calculate.dart';
import 'package:mytokenview/widget/history.dart';

class ContractDetailPage extends StatefulWidget {
  final String code;
  final String apiKey;

  const ContractDetailPage({Key? key, required this.code, required this.apiKey})
      : super(key: key);

  @override
  _ContractDetailPageState createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  late Contract contract;
  late Coin coin;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshContract();
  }

  Future refreshContract() async {
    setState(() => isLoading = true);

    this.contract = await TokenDB.instance.readContractCode(widget.code);
    var response = await getToken(widget.code.toUpperCase(), widget.apiKey);

    if (response['error'] == null) {
      this.coin = Coin.fromJson(response);
    }

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
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildIconAndName(contract, coin),
                        SizedBox(height: 20),
                        Calculator(
                            decimals: contract.decimals != null
                                ? contract.decimals
                                : 2,
                            price: coin.rate),
                        SizedBox(height: 20),
                        Expanded(
                            child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          children: [
                            ListHistory(
                              code: widget.code.toUpperCase(),
                              decimals: contract.decimals,
                              apiKey: widget.apiKey,
                            ),
                          ],
                        )),
                      ]),
                )),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditContractPage(
            contract: contract,
            apiKey: widget.apiKey,
          ),
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

  Widget _buildIconAndName(Contract data, Coin coin) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(flex: 0, child: Image.network(data.img, height: 32)),
        Expanded(
            flex: 1, child: _buildTextName(data.name, coin.rate, data.decimals))
      ],
    ));
  }

  Widget _buildTextName(String data, double price, int? decimals) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(' $data',
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          )),
      Text(
        ' ${getPriceFormat(price, decimals)}',
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      )
    ]);
  }
}
