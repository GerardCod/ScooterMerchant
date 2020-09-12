import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart';

class TimeZoneProvider {
  TimeZoneProvider() {
    this.setUp();
  }

  void setUp() async {
    final data = await rootBundle.load('packages/timezone/data/2020a.tzf');
    print(data.toString());
    initializeDatabase(data.buffer.asUint8List());
  }

  String convertLocalToDetroit(DateTime date) {
    return TZDateTime.from(date, getLocation('America/Detroit')).toString();
  }
}
