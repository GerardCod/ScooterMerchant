import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:scootermerchant/src/models/merchant_model.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/src/providers/notification_provider.dart';

import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/src/models/auth_model.dart';

class LoginProvider {
  String _baseUrl = baseUrl;
  final _prefs = MerchantPreferences();
  final pushProvider = new NotificationsProvider();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> login(AuthModel model) async {
    try {
      final response =
          await http.post(_baseUrl + 'merchants/login/', body: model.toMap());
      String source = Utf8Decoder().convert(response.bodyBytes);
      Map<String, dynamic> decodedResp = json.decode(source);
      print(decodedResp);
      if (decodedResp.containsKey('access')) {
        _prefs.access = decodedResp['access'];
        _prefs.refresh = decodedResp['refresh'];
        _prefs.merchant = MerchantModel.fromJson(decodedResp['merchant']);

        _firebaseMessaging.getToken().then((value) async {
          await pushProvider.registrarToken(value);
        });

        return {'ok': true, 'access': decodedResp['access']};
      }

      return {'ok': false, 'message': decodedResp['errors']['message']};
    } catch (e) {
      print(e);
      return {'ok': false, 'message': e.toString()};
    }
  }
}
