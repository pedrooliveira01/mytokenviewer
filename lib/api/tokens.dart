import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> getToken(String code) async {
  var url = Uri.parse('https://api.livecoinwatch.com/coins/single');

  var requestBody = jsonEncode(
      <String, String>{'currency': 'USD', 'code': '$code', 'meta': 'true'});
  var request = await http.post(url,
      headers: {
        'content-type': 'application/json',
        'x-api-key': '26d5c603-6332-4c9f-aaf4-6f54abe71f86'
      },
      body: requestBody);
  return json.decode(request.body);
}

Future<dynamic> getTokenHist(String code) async {
  var url = Uri.parse('https://api.livecoinwatch.com/coins/single/history');

  int startDate =
      DateTime.now().subtract(const Duration(hours: 12)).millisecondsSinceEpoch;
  int endDate = DateTime.now().millisecondsSinceEpoch;

  var requestBody = jsonEncode(<String, dynamic>{
    'currency': 'USD',
    'code': '$code',
    'meta': 'true',
    'start': startDate,
    'end': endDate
  });
  var request = await http.post(url,
      headers: {
        'content-type': 'application/json',
        'x-api-key': '26d5c603-6332-4c9f-aaf4-6f54abe71f86'
      },
      body: requestBody);
  return json.decode(request.body);
}
