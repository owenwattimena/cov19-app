// import 'package:cov19_app/app/repositories/data_repositories.dart';
import 'package:cov19_app/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  final String title;
  final String iconPath;
  final Color color;

  EndpointCardData(
      {required this.title, required this.iconPath, required this.color});
}

class EndpointCard extends StatelessWidget {
  final Endpoint endpoint;
  final int? value;

  const EndpointCard({Key? key, required this.endpoint, this.value})
      : super(key: key);

  static Map<Endpoint, EndpointCardData> endpoints = {
    Endpoint.cases: EndpointCardData(
        title: "Cases", iconPath: "assets/count.png", color: Color(0xffFFF492)),
    Endpoint.casesConfirmed: EndpointCardData(
        title: "Cases Confirmed",
        iconPath: "assets/fever.png",
        color: Color(0xffEEDA28)),
    Endpoint.casesSuspected: EndpointCardData(
        title: "Cases Suspected",
        iconPath: "assets/suspect.png",
        color: Color(0xffEEDA28)),
    Endpoint.deaths: EndpointCardData(
        title: "Deaths",
        iconPath: "assets/death.png",
        color: Color(0xffE40000)),
    Endpoint.recovered: EndpointCardData(
        title: "Recovered",
        iconPath: "assets/patient.png",
        color: Color(0xff70A901))
  };


  String get formattedValue{
    if(value == null){
      return "";
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              endpoints[endpoint]!.title,
              style: Theme.of(context).textTheme.headline6!.copyWith(color:endpoints[endpoint]!.color),
            ),
            SizedBox(height: 8),
            SizedBox(
              height:52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(endpoints[endpoint]!.iconPath, color: endpoints[endpoint]!.color),
                  Text(
                    formattedValue,
                    style: Theme.of(context).textTheme.headline4!.copyWith(color:endpoints[endpoint]!.color),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
