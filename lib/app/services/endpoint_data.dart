class EndpointData {
  final int value;
  final DateTime? dateTime;

  EndpointData({required this.value, this.dateTime});

  @override
  String toString() {
    return "value : $value, dateTime : $dateTime";
  }
}
