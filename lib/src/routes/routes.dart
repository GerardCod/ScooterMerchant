import 'package:flutter/material.dart';
import 'package:scootermerchant/src/pages/drawer/change_password/change_password_page.dart';
import 'package:scootermerchant/src/pages/drawer/products/list_products_page.dart';
import 'package:scootermerchant/src/pages/forgot_password/forgot_password_page.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/src/pages/login_page/login_page.dart';
import 'package:scootermerchant/src/pages/notification_order_details/notification_color_page.dart';
import 'package:scootermerchant/src/pages/product_details/product_details_page.dart';
import 'package:scootermerchant/src/pages/shared/new_version_page.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  'loginPage': (BuildContext context) => LoginPage(),
  'homePage': (BuildContext context) => HomePage(),
  'changePasswordPage': (BuildContext context) => ChangePasswordPage(),
  'forgotPasswordPage': (BuildContext context) => ForgotPasswordPage(),
  'listProductsPage': (BuildContext context) => ListProductsPage(),
  'productDetailsPage': (BuildContext context) => ProductDetailsPage(),
  'notificationColorPage': (BuildContext context) => NotificationColorPage(),
  'newObligatoryVersionPage': (BuildContext context) => NewVersionPage(),
};

String getInitialRoute(MerchantPreferences prefs) =>
    prefs.access == null ? 'loginPage' : 'homePage';
