import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:scootermerchant/utilities/constants.dart';

class NotificationsProvider {
  // Local notifications
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  // Preferencias
  final _prefs = new MerchantPreferences();
  String _baseUrl = baseUrl;

  Stream<Map<String, dynamic>> get messages => _messageStreamController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    print('====== onBackgroundMessage ====== ');

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotifications() async {
    // Local notifications
    var initializationSettingsAndroid =
        AndroidInitializationSettings('scooterlogo');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
    // Termina local notifications

    // _firebaseMessaging.requestNotificationPermissions();

    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();

    print('==== FCM Token ======');
    print(token);

    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage:
          Platform.isIOS ? null : NotificationsProvider.onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<Map<String, StringConversionSink>> registrarToken(String token) async {
    final url = _baseUrl + 'devices/';
    final authData = {
      "registration_id": token,
      "type": Platform.isAndroid ? 'android' : 'ios'
    };

    // print('AQUIIII');
    // print(authData);

    http.Response resp = await http.post(Uri.encodeFull(url),
        headers: {
          "Authorization": "Bearer " + _prefs.access,
        },
        body: authData);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      // print(url);
      // print(resp.body);
      return null;
    }

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print('Registrar Token');
    // print(decodedResp);
    // print(statusCode);
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    // ================== ON MESSGAE =========================
    // await _createNofification(message);
    print('====== onMessage ====== ');
    print('message: $message');
    await _createNofification(message);

    Map<String, dynamic> argument = {'data': 'no-data', 'type': 'no-type'};

    String dataMessage = '';
    String typeMessage = '';
    if (Platform.isAndroid) {
      dataMessage = message['data']['order_id'] ?? 'no-data';
      typeMessage = message['data']['type'] ?? 'no-type';
    } else {
      dataMessage = message['order_id'] ?? 'no-data';
      typeMessage = message['type'] ?? 'no-type';
    }
    argument['data'] = dataMessage;
    argument['type'] = typeMessage;

    _messageStreamController.sink.add(argument);
    return Future<void>.value();
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print('====== onLaunch ====== ');
    print('message: $message');

    // ================== ON LAUNCH =========================

    await _createNofification(message);

    Map<String, dynamic> argument = {'data': 'no-data', 'type': 'no-type'};

    String dataMessage = '';
    String typeMessage = '';
    if (Platform.isAndroid) {
      dataMessage = message['data']['order_id'] ?? 'no-data';
      typeMessage = message['data']['type'] ?? 'no-type';
    } else {
      dataMessage = message['order_id'] ?? 'no-data';
      typeMessage = message['type'] ?? 'no-type';
    }
    argument['data'] = dataMessage;
    argument['type'] = typeMessage;

    _messageStreamController.sink.add(argument);
    return Future<void>.value();
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    // await _createNofification(message);
    print('====== onResume ====== ');
    print('message: $message');

    Map<String, dynamic> argument = {'data': 'no-data', 'type': 'no-type'};

    String dataMessage = '';
    String typeMessage = '';
    if (Platform.isAndroid) {
      dataMessage = message['data']['order_id'] ?? 'no-data';
      typeMessage = message['data']['type'] ?? 'no-type';
    } else {
      dataMessage = message['order_id'] ?? 'no-data';
      typeMessage = message['type'] ?? 'no-type';
    }
    argument['data'] = dataMessage;
    argument['type'] = typeMessage;

    _messageStreamController.sink.add(argument);
    return Future<void>.value();
  }

  Future<void> _showNotification(title, body, data) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'messages',
      'Messages',
      'channel for messages',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      visibility: NotificationVisibility.Public,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return await notificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: data);
  }

  Future<dynamic> _createNofification(message) async {
    if (message.containsKey('notification')) {
      var notification = message['notification'];
      return await _showNotification(notification['title'],
          notification['body'], message['data'].toString());
    }
  }

  dispose() {
    _messageStreamController?.close();
  }
}
