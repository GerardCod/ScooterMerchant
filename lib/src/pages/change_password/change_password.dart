import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cambiar contraseña',
          style: textStyleBtnComprar,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text('Cambiar contraseña'),
      ),
    );
  }
}
