import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/src/providers/notification_provider.dart';
import 'package:scootermerchant/src/routes/routes.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new MerchantPreferences();
  await prefs.initPrefs();
  await refreshToken(prefs.access, prefs);
  runApp(MyApp(prefs));
}

class MyApp extends StatefulWidget {
  final prefs;
  // final notificationProvider = new NotificationsProvider();

  MyApp(this.prefs);

  @override
  _MyAppState createState() => _MyAppState(prefs);
}

class _MyAppState extends State<MyApp> {
  final MerchantPreferences prefs;

  _MyAppState(this.prefs);

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final notificationProvider = new NotificationsProvider();
    notificationProvider.initNotifications();
    notificationProvider.messages.listen((data) {
      if (data['type'] == 'NEW_ORDER') {
        navigatorKey.currentState
            // .pushNamed('notificationOrderDetails', arguments: data['data']);
            .pushNamed('notificationColorPage');
      }
    });
    _verifyUpdates(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Scooter',
        navigatorKey: navigatorKey,
        initialRoute: getInitialRoute(prefs),
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColor: primaryColor, accentColor: secondaryColor),
        routes: routes,
      ),
    );
  }
}

// VerifyUpdates in PlayStore
Future<Null> _verifyUpdates(GlobalKey<NavigatorState> navigatorKey) {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    final String currentVersion = packageInfo.buildNumber;
    checkVersion().then((Map<String, dynamic> response) {
      int newVersion = response['data']['build_number'];
      if (int.parse(currentVersion) < newVersion) {
        navigatorKey.currentState
            .pushReplacementNamed('newObligatoryVersionPage');
      }
    });
  });
}

Future<void> refreshToken(token, MerchantPreferences _prefs) async {
  if (token != null) {
    final jwt = parseJwtPayLoad(token);
    final DateTime currentDate = DateTime.now();
    final int exp = jwt['exp'];
    final timeExp = exp * 1000;
    const HOUR_DIFF = (5 * 60 * 60 * 2000);

    if (timeExp > (currentDate.millisecondsSinceEpoch + HOUR_DIFF)) {
      print("Token not experied");
    } else {
      print("Refresh token");
      return await apiRefreshToken(_prefs);
    }
  }
}

Future<Map<String, dynamic>> apiRefreshToken(MerchantPreferences _prefs) async {
  String _baseUrl = baseUrl;

  final data = {
    "refresh": _prefs.refresh,
  };
  final resp = await http.post(_baseUrl + "users/token/refresh/", body: data);

  Map<String, dynamic> decodedResp = json.decode(resp.body);
  if (decodedResp.containsKey('access')) {
    //Salvar el token en el storage
    _prefs.access = decodedResp['access'];
    // Notifications
    _firebaseMessaging.getToken().then((value) async {
      await NotificationsProvider().registrarToken(value);
    });
    return {'ok': true, 'access': decodedResp['access']};
  } else {
    _prefs.access = null;
    return {'ok': false, 'message': decodedResp['errors']['message']};
  }
}

Future<Map<String, dynamic>> checkVersion() async {
  String _baseUrl = baseUrl;
  final resp = await http.get(_baseUrl + "users/check_version_merchant/");

  String source = Utf8Decoder().convert(resp.bodyBytes);

  Map<String, dynamic> decodedResp = json.decode(source);

  if (resp.statusCode >= 400) {
    return {'ok': false, 'message': decodedResp['errors']['message']};
  } else {
    return {'ok': true, 'data': decodedResp};
  }
}
