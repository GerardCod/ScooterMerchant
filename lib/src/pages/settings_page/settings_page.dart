import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: textStyleBtnComprar,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('Settings page'),
      ),
    );
  }
}
