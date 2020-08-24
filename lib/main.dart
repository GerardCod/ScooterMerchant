import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/src/pages/login_page.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new MerchantPreferences();
  await prefs.initPrefs();

  runApp(MyApp(prefs));
}

class MyApp extends StatefulWidget {
  final prefs;

  MyApp(this.prefs);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Scooter',
        initialRoute: 'login',
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(primaryColor: primaryColor, accentColor: secondaryColor),
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage()
        },
      ),
    );
  }
}
