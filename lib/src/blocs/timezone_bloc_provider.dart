import 'package:scootermerchant/src/providers/time_zone_provider.dart';

class TimeZoneBlocProvider {
  final TimeZoneProvider _provider = TimeZoneProvider();

  String convertLocalToDetroit(String date) {
    return _provider.convertLocalToDetroit(DateTime.parse(date));
  }
}
