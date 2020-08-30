import 'package:flutter/material.dart';
import 'package:scootermerchant/src/pages/forgot_password/forgot_password_page.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/src/pages/login_page/login_page.dart';
import 'package:scootermerchant/src/pages/notification_order_details/notification_order_details_page.dart';
import 'package:scootermerchant/src/pages/order_details/order_details_page.dart';
import 'package:scootermerchant/src/pages/change_password/change_password.dart';
import 'package:scootermerchant/src/pages/settings_page/settings_page.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  'login': (BuildContext context) => LoginPage(),
  'home': (BuildContext context) => HomePage(),
  'orderDetails': (BuildContext context) => OrderDetailsPage(),
  'notificationOrderDetails': (BuildContext context) =>
      NotificationOrderDetailsPage(),
  'settings': (BuildContext context) => SettingsPage(),
  'forgotPassword': (BuildContext context) => ForgotPasswordPage(),
  'changePassword': (BuildContext context) => ChangePasswordPage(),
};

String getInitialRoute(MerchantPreferences prefs) =>
    prefs.access == null ? 'login' : 'home';
