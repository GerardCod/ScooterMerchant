import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_header(context), _formLogin(context)],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final size = MediaQuery.of(context).size;
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

  Widget _formLogin(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          _formContainer(size.width * 0.85, size.height * 0.6),
          SizedBox(
            height: 15.0,
            width: size.width,
          ),
          FlatButton(
              onPressed: () {},
              child: Text('Olvidé mi contraseña', style: textHypervincule)),
        ],
      ),
    );
  }

  Widget _formContainer(double width, double height) {
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
            'Bienvenido querido comerciante',
            style: textStyleTitleListTile,
          ),
          Expanded(
            child: Container(),
          ),
          _createTextField(TextInputType.emailAddress, 'Ingresa tu correo',
              false, Icons.alternate_email),
          SizedBox(
            height: 40.0,
          ),
          _createTextField(TextInputType.visiblePassword,
              'Ingresa tu contraseña', true, Icons.lock),
          SizedBox(
            height: 30.0,
          ),
          RaisedButton(
            onPressed: () {},
            color: primaryColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Text('Ingresar', style: textStyleBtnComprar),
          )
        ],
      ),
    );
  }

  Widget _createTextField(
      TextInputType type, String label, bool obscureText, IconData icon) {
    return TextField(
      keyboardType: type,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
    );
  }
}
