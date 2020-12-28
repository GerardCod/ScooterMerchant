import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

class ForgotPasswordPage extends StatelessWidget {
  LoginBloc loginBloc;
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    loginBloc = Provider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _customAppBar(),
      body: _customBody(context),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text('Olvidé mi contraseña', style: txtStyleAppBar),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  Widget _customBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              Text(
                'Te enviaremos un mensaje a tu correo para que puedas recuperar tu contraseña',
                style: textStyleTitleListTile,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              _emailStreamBuilder(),
              SizedBox(height: 16.0),
              _buttonForm()
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailStreamBuilder() {
    return StreamBuilder(
        stream: loginBloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo electrónico',
                // contentPadding:
                //     EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                prefixIcon: Icon(Icons.alternate_email),
                errorText: snapshot.error),
            onChanged: loginBloc.changeEmail,
          );
        });
  }

  Widget _buttonForm() {
    return StreamBuilder(
        stream: loginBloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return RaisedButton(
            onPressed: snapshot.hasData
                ? () => _forgotPassword(loginBloc.email, context)
                : null,
            color: primaryColor,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Text('Enviar', style: textStyleBtnComprar),
          );
        });
  }

  Future<void> _forgotPassword(String email, BuildContext context) async {
    final response = await loginBloc.forgotPassword(email: email);

    if (response['ok']) {
      // loginBloc.changeEmail(null);
      showSnackBar(context, response['message'], colorSuccess);

    } else {
      showSnackBar(context, response['message'], colorDanger);
    }
  }
}
