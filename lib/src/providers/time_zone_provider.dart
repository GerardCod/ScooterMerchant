import 'package:flutter/services.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:timezone/timezone.dart';

class TimeZoneProvider {
  TimeZoneProvider() {
    this.setUp();
  }

  void setUp() async {
    final data = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(data.buffer.asUint8List());
  }

  DateTime convertLocalToMexico(String date) {
    return TZDateTime.from(DateTime.parse(date), getLocation(location));
  }

  Map<String, Location> get locations {
    return timeZoneDatabase.locations;
  }
}
