import 'package:flutter/material.dart';
import 'package:mytokenview/api/tokens.dart';
import 'package:mytokenview/utils/price_format.dart';
import 'package:shimmer/shimmer.dart';

Widget ContractCardWidget(String code, int? decimals) {
  bool isLoading = false;

  Future<dynamic> getTokenData() async {
    isLoading = true;
    var result = await getToken(code.toUpperCase());
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
                              _buildIconAndName((snapshot.data as dynamic)),
                              SizedBox(height: 5),
                              _buildTextPrice(
                                  (snapshot.data as dynamic), decimals),
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

Widget _buildIconAndName(dynamic data) {
  return Container(
      child: Row(
    children: <Widget>[
      Expanded(flex: 0, child: Image.network(data['png32'], height: 16)),
      Expanded(flex: 1, child: _buildTextName(data))
    ],
  ));
}

Widget _buildTextName(dynamic data) {
  return Text(
    ' ${data['name']}',
    maxLines: 1,
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: Colors.grey,
      fontSize: 14,
    ),
  );
}

Widget _buildTextPrice(dynamic data, int? decimals) {
  return Container(
      alignment: Alignment.centerRight,
      child: (Text(
        getPriceFormat(data['rate'], decimals),
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
