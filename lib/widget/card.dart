import 'package:flutter/material.dart';
import 'package:mytokenview/api/tokens.dart';
import 'package:mytokenview/model/coin.dart';
import 'package:mytokenview/utils/price_format.dart';
import 'package:shimmer/shimmer.dart';

Widget ContractCardWidget(String code, int? decimals, String apiKey) {
  bool isLoading = false;
  late Coin coin;

  Future<dynamic> getTokenData() async {
    isLoading = true;
    var result = await getToken(code.toUpperCase(), apiKey);
    coin = Coin.fromJson(result);
    isLoading = false;
    return result;
  }

  return Container(
      child: FutureBuilder(
          future: getTokenData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return isLoading
                  ? _buildLoadingCard()
                  : Center(
                      child: Card(
                        color: Colors.transparent,
                        child: Container(
                          constraints: BoxConstraints(minHeight: 60),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            children: [
                              _buildIconAndName(coin),
                              SizedBox(height: 5),
                              _buildTextPrice(coin, decimals),
                            ],
                          ),
                        ),
                      ),
                    );
            } else {
              return _buildLoadingCard();
            }
          }));
}

Widget _buildIconAndName(Coin coin) {
  return Container(
      child: Row(
    children: <Widget>[
      Expanded(flex: 0, child: Image.network(coin.png32, height: 16)),
      Expanded(flex: 1, child: _buildTextName(coin))
    ],
  ));
}

Widget _buildTextName(Coin coin) {
  return Text(
    ' ${coin.name}',
    maxLines: 1,
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
  );
}

Widget _buildTextPrice(Coin coin, int? decimals) {
  return Container(
      alignment: Alignment.centerRight,
      child: (Text(
        getPriceFormat(coin.rate, decimals),
        maxLines: 1,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      )));
}

Widget _buildLoadingCard() {
  return SizedBox(
    width: 200.0,
    height: 70.0,
    child: Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Colors.grey.shade900,
      child: Card(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(minHeight: 100),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
          ),
        ),
      ),
    ),
  );
}
