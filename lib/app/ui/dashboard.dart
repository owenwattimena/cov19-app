import 'dart:io';

import 'package:cov19_app/app/repositories/data_repositories.dart';
import 'package:cov19_app/app/repositories/endpoints_data.dart';
import 'package:cov19_app/app/services/api.dart';
import 'package:cov19_app/app/ui/endpoint_card.dart';
import 'package:cov19_app/app/ui/last_updated_status.dart';
import 'package:cov19_app/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData? _data;

  Future<void> updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepositories>(context, listen: false);

      final data = await dataRepository.getAllEndpointsData();
      setState(() => _data = data);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: 'Connection Error',
        content:
            'Could not retrieve data. Please check your internet connection',
        defaultActionText: 'OK',
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: 'Unknown Error',
        content: 'Please contact support or try again later',
        defaultActionText: 'OK',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final dataRepository =
        Provider.of<DataRepositories>(context, listen: false);
    _data = dataRepository.getAllEndpointsCacheData();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    final lastUpdatedFormatter = LastDateFormatter(
        lastUpdated:
            _data != null ? _data!.values[Endpoint.cases]?.dateTime : null);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Coronavirus Tracker'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: updateData,
        child: ListView(
          children: [
            LastUpdatedStatus(
                stringDate: lastUpdatedFormatter.stringFormatter()),
            ...Endpoint.values.map(
              (e) => EndpointCard(
                endpoint: e,
                value: _data != null ? _data?.values[e]?.value : null,
              ),
            ),
            // for (var endpoint in Endpoint.values)
            //   EndpointCard(
            //     endpoint: endpoint,
            //     value: _data != null ? _data!.values[endpoint]!.value : null,
            //   )
          ],
        ),
      ),
    );
  }
}
