import 'package:flutter/material.dart';
import 'package:mytokenview/api/tokens.dart';
import 'package:mytokenview/utils/date_format.dart';
import 'package:mytokenview/utils/price_format.dart';
import 'package:shimmer/shimmer.dart';

class ListHistory extends StatefulWidget {
  final String code;
  final String apiKey;
  final int? decimals;

  const ListHistory(
      {Key? key, required this.code, this.decimals, required this.apiKey})
      : super(key: key);

  @override
  _ListHistoryState createState() => _ListHistoryState();
}

Future<dynamic> fetchData(String code, String apiKey) async {
  return await getTokenHist(code, apiKey);
}

class _ListHistoryState extends State<ListHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: fetchData(widget.code, widget.apiKey),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data['history'];
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return _buildLoadingCard();
      },
    );
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        reverse: true,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: data.length,
        itemExtent: 40,
        itemBuilder: (context, index) {
          return _tile(data[index]['rate'], data[index]['date'],
              data[index > 0 ? index - 1 : index]['rate']);
        });
  }

  ListTile _tile(double price, int timestamp, double lastPrice) => ListTile(
        title: Row(children: [
          Text(getDateTimeStrFromTimeStampo(timestamp),
              style: TextStyle(fontSize: 15, color: Colors.grey)),
          Spacer(),
          Text(getPriceFormat(price, widget.decimals),
              style: TextStyle(fontSize: 18, color: Colors.white))
        ]),

        /* subtitle: Text(getPriceFormat(price, widget.decimals),
            style: TextStyle(fontSize: 18, color: Colors.white)),*/
        leading: Icon(
          price > lastPrice
              ? Icons.arrow_drop_up_outlined
              : price < lastPrice
                  ? Icons.arrow_drop_down_outlined
                  : Icons.swap_horiz_outlined,
          color: price > lastPrice
              ? Colors.green
              : price < lastPrice
                  ? Colors.red
                  : Colors.yellow,
        ),
      );

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
}
