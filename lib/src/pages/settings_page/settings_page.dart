import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/utilities/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = Provider.of(context);

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

  void _showSnackbar(BuildContext context, String message, Color color) {
    final SnackBar snackbar = SnackBar(
      content: Text(message, style: textStyleSnackBar),
      backgroundColor: color,
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }
}
