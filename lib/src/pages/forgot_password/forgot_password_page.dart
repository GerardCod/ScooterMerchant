import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/utilities/constants.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final LoginBloc bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ovlidé mi contraseña', style: textStyleBtnComprar),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: <Widget>[
          _header(size),
          _formForgotPassword(bloc, size, context)
        ],
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

  Widget _formForgotPassword(LoginBloc bloc, Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text('SCOOTER', style: textStyleScooter),
          SizedBox(
            height: 20.0,
          ),
          _formContainer(size.width * 0.85, size.height * 0.7, bloc),
          SizedBox(
            height: 15.0,
            width: size.width,
          ),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Regresar', style: textHypervincule)),
        ],
      ),
    );
  }

  Widget _formContainer(double width, double height, LoginBloc bloc) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 2.5),
                blurRadius: 1.5,
                spreadRadius: 1.5)
          ],
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Column(
        children: <Widget>[
          Text(
            'Un email te será enviado para recuperar tu contraseña',
            style: textStyleTitleListTile,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Container(),
          ),
          _emailStreamBuilder(bloc),
          SizedBox(height: 16.0),
          _buttonForm(bloc)
        ],
      ),
    );
  }

  Widget _emailStreamBuilder(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Correo electrónico',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                prefixIcon: Icon(Icons.alternate_email),
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          );
        });
  }

  Widget _buttonForm(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return RaisedButton(
            onPressed: snapshot.hasData
                ? () => _forgotPassword(bloc.email, context, bloc)
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

  Future<void> _forgotPassword(
      String email, BuildContext context, LoginBloc bloc) async {
    final response = await bloc.forgotPassword(email: email);

    if (response['ok']) {
      _showSnackbar(context, response['message'], colorSuccess);
    } else {
      _showSnackbar(context, response['message'], colorDanger);
    }
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    final SnackBar snackbar = SnackBar(
      content: Text(
        message,
        style: textStyleSnackBar,
      ),
      backgroundColor: color,
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
