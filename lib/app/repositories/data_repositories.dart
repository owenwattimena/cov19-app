import 'package:cov19_app/app/repositories/endpoints_data.dart';
import 'package:cov19_app/app/services/api.dart';
import 'package:cov19_app/app/services/api_service.dart';
import 'package:cov19_app/app/services/data_cache_service.dart';
import 'package:cov19_app/app/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepositories {
  final APIService service;
  final DataCacheService dataCacheService;

  DataRepositories({required this.service, required this.dataCacheService});

  String? _accessToken;

  Future<EndpointData?> getEndpoinData(Endpoint endpoint) async {
    return await _getDataRefreshingToken<EndpointData>(onGetData: () async {
      EndpointData result = await service.getEndpointData(
          accessToken: _accessToken!, endpoint: endpoint);
      return result;
    });
  }

  EndpointsData getAllEndpointsCacheData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
        onGetData: _getAllEndpointsData);
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await service.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await service.getAccessToken();
        return await onGetData();
      } else {
        rethrow;
      }
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      service.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.cases),
      service.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.casesConfirmed),
      service.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.casesSuspected),
      service.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.deaths),
      service.getEndpointData(
          accessToken: _accessToken!, endpoint: Endpoint.recovered),
    ]);

    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesConfirmed: values[1],
      Endpoint.casesSuspected: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    });
  }
}
