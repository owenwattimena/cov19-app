import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastDateFormatter{
  final DateTime? lastUpdated;

  LastDateFormatter({this.lastUpdated});

  stringFormatter(){
    if(lastUpdated != null){
      final dateFormat = DateFormat('EE, d MMMM y').add_Hm();
      final dateTime = dateFormat.format(lastUpdated!);
      return "Last updated $dateTime";
    }
    return "";
  }
}

class LastUpdatedStatus extends StatelessWidget {
  final String stringDate;

  const LastUpdatedStatus({Key? key, required this.stringDate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        stringDate,
        textAlign: TextAlign.center,
      ),
    );
  }
}