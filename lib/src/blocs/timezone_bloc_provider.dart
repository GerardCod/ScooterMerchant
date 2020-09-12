import 'package:scootermerchant/src/providers/time_zone_provider.dart';
import 'package:timezone/timezone.dart';

class TimeZoneBlocProvider {
  final TimeZoneProvider _provider = TimeZoneProvider();

  DateTime convertLocalToMexico(String date) {
    return _provider.convertLocalToMexico(date);
  }

  Map<String, Location> get locations {
    return _provider.locations;
  }
}
