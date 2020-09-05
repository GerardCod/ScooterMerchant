import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/auth_model.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Center(child: _formLogin(context)),
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
    final bloc = Provider.of(context);

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
          _formContainer(bloc),
          SizedBox(
            height: 15.0,
            width: size.width,
          ),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('forgotPassword');
              },
              child:
                  Text('Olvidé mi contraseña', style: textHypervinculeWhite)),
        ],
      ),
    );
  }

  Widget _formContainer(LoginBloc bloc) {
    return Container(
      padding: EdgeInsets.all(24.0),
      margin: EdgeInsets.all(16.0),
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
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 48.0,
          ),
          _emailStreamBuilder(bloc),
          SizedBox(height: 16.0),
          _passwordStreamBuilder(bloc),
          SizedBox(
            height: 16.0,
          ),
          _buttonForm(bloc)
        ],
      ),
    );
  }

  Widget _buttonForm(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.validationStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            onPressed: snapshot.hasData
                ? () => _login(bloc.email, bloc.password, context, bloc)
                : null,
            color: primaryColor,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: StreamBuilder<bool>(
              stream: bloc.showLoaderStream,
              // initialData: initialData ,
              builder: (context, snapshotLoader) {
                return Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Ingresar', style: textStyleBtnComprar),
                      Visibility(
                        visible: snapshotLoader.hasData &&
                            snapshotLoader.data == true,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  Future<void> _login(String email, String password, BuildContext context,
      LoginBloc bloc) async {
    final user = AuthModel(username: email, password: password);
    final response = await bloc.login(user);
    if (response['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showSnackBar(context, 'Usuario o contraseña incorrectos.', colorDanger);
    }
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

  Widget _passwordStreamBuilder(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Contraseña',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              prefixIcon: Icon(Icons.lock),
              errorText: snapshot.error),
          obscureText: true,
          onChanged: bloc.changePassword,
        );
      },
    );
  }
}
