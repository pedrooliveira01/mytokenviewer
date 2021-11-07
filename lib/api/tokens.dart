import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> getApiToken() async {
  var envApi = dotenv.get('API_TOKENS', fallback: '');
  var apis = json.decode(envApi);
  var tokenAPI = '';
  var tokenUsage = 0;

  for (var api in apis) {
    var response = await getCredits(api);
    var usages = response['dailyCreditsRemaining'];
    if (usages > 0) {
      if (tokenAPI == '' || tokenUsage < usages) {
        tokenAPI = api;
        tokenUsage = usages;
        if (usages == 10000) {
          break;
        }
      }
    }
  }
  return tokenAPI;
}

Future<dynamic> getToken(String code, String apikey) async {
  var url = Uri.parse('https://api.livecoinwatch.com/coins/single');

  var requestBody = jsonEncode(
      <String, String>{'currency': 'USD', 'code': '$code', 'meta': 'true'});
  var request = await http.post(url,
      headers: {'content-type': 'application/json', 'x-api-key': '$apikey'},
      body: requestBody);
  return json.decode(request.body);
}

Future<dynamic> getTokenHist(String code, String apikey) async {
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
      headers: {'content-type': 'application/json', 'x-api-key': '$apikey'},
      body: requestBody);
  return json.decode(request.body);
}

Future<dynamic> getCredits(String api) async {
  var url = Uri.parse('https://api.livecoinwatch.com/credits');

  var request = await http.post(url,
      headers: {'content-type': 'application/json', 'x-api-key': '${api}'},
      body: '{}');
  return json.decode(request.body);
}
