import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/pages/login_page.dart';
import 'package:scootermerchant/utilities/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        },
      ),
    );
  }
}
