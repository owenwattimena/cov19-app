import 'dart:convert';
import 'package:cov19_app/app/services/endpoint_data.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class APIService {
  final API api;

  APIService({required this.api});

  Future<String> getAccessToken() async {
    // var client = http.Client();
    final response = await http.post(api.tokenUri(),
        headers: {"Authorization": "Basic ${api.apiKey}"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        "Request to ${api.tokenUri().toString()} failed\n${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  Future<EndpointData> getEndpointData({
    required String accessToken,
    required Endpoint endpoint,
  }) async {
    final uri = api.endpointUri(endpoint);
    final response =
        await http.get(uri, headers: {"Authorization": "Bearer $accessToken"});
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final int? value = endpointData[_responseJsonKeys[endpoint]];
        final String dateString = endpointData['date'];
        final date = DateTime.tryParse(dateString);
        if (value != null) {
        return EndpointData(value: value, dateTime: date);
        }
      }
    }
    print(
        "Request to ${api.tokenUri().toString()} failed\n${response.statusCode} ${response.reasonPhrase}");
    throw response;
  }

  static Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: 'cases',
    Endpoint.casesConfirmed: 'data',
    Endpoint.casesSuspected: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data',
  };
}
