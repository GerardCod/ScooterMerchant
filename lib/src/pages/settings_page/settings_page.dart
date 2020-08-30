import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    final String token = MerchantPreferences().access;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: textStyleBtnComprar,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            _header(size),
            _formChangePassword(bloc, token, context)
          ],
        ),
      ),
    );
  }

  Widget _header(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.45,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              textColorTF,
            ],
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0))),
    );
  }

  Widget _formChangePassword(
      LoginBloc bloc, String token, BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        shape: radiusButtons,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Cambio de contraseña',
                  textAlign: TextAlign.center, style: textStyleTitleListTile),
              SizedBox(
                height: 15.0,
              ),
              _passwordStreamBuilder(bloc),
              _confirmPasswordStreamBuilder(bloc),
              _buttonStreamBuilder(bloc, token, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordStreamBuilder(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                prefixIcon: Icon(Icons.lock),
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
            obscureText: true,
          );
        });
  }

  Widget _confirmPasswordStreamBuilder(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.confirmPasswordStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirmar contraseña',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                prefixIcon: Icon(Icons.lock),
                errorText: snapshot.error),
            onChanged: bloc.changeConfirmPassword,
            obscureText: true,
          );
        });
  }

  Widget _buttonStreamBuilder(
      LoginBloc bloc, String token, BuildContext context) {
    return StreamBuilder(
      stream: bloc.comparePasswordsStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
            color: secondaryColor,
            child: Text('Cambiar contraseña', style: textStyleBtnComprar),
            shape: radiusButtons,
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            onPressed: snapshot.hasData
                ? () => this._changePassword(
                    password: bloc.confirmPassword,
                    bloc: bloc,
                    token: token,
                    context: context)
                : null);
      },
    );
  }

  Future<void> _changePassword(
      {String password,
      String token,
      LoginBloc bloc,
      BuildContext context}) async {
    final response =
        await bloc.updatePassword(password: password, token: token);
    if (response['ok']) {
      showSnackBar(context, 'Contraseña cambiada con éxito.', colorSuccess);
    } else {
      showSnackBar(context, 'Error al cambiar la contraseña.', colorDanger);
    }
  }
}
