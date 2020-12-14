import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/auth_model.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key key}) : super(key: key);
  LoginBloc loginBloc;
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    loginBloc = Provider.of(context);
    return Scaffold(
      appBar: _customAppBar(),
      backgroundColor: Colors.white,
      body: _customBody(context),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _customBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/icon/icon_launcher.jpg', height: 160),
              SizedBox(
                height: 20,
              ),
              Text(
                'Bienvenido comerciante',
                style: textStyleTitleListTile,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 25,
              ),
              _emailStreamBuilder(),
              SizedBox(height: 16.0),
              _passwordStreamBuilder(),
              SizedBox(
                height: 16.0,
              ),
              _buttonForm(),
              // _formContainer(),
              SizedBox(
                height: 15.0,
                width: size.width,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('forgotPasswordPage');
                },
                child:
                    Text('Olvidé mi contraseña', style: textHypervinculeWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonForm() {
    return StreamBuilder(
        stream: loginBloc.validationStream,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: snapshot.hasData ? () => _login(context) : null,
            color: primaryColor,
            textColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: StreamBuilder<bool>(
              stream: loginBloc.showLoaderStream,
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

  Future<void> _login(BuildContext context) async {
    final user =
        AuthModel(username: loginBloc.email, password: loginBloc.password);
    final response = await loginBloc.login(user);
    if (response['ok']) {
      Navigator.pushReplacementNamed(context, 'homePage');
    } else {
      // print("Response=============================");
      // print(response);
      showSnackBar(context, 'Usuario o contraseña incorrectos.', colorDanger);
    }
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                prefixIcon: Icon(Icons.alternate_email),
                errorText: snapshot.error),
            onChanged: loginBloc.changeEmail,
          );
        });
  }

  Widget _passwordStreamBuilder() {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return StreamBuilder<bool>(
          stream: loginBloc.showPasswordStream,
          builder: (BuildContext context, AsyncSnapshot snapshotShowPassword) {
            return TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    if (snapshotShowPassword.data == null) {
                      loginBloc.changeShowPassword(false);
                    }
                    loginBloc.changeShowPassword(!snapshotShowPassword.data);
                  },
                ),
                errorText: snapshot.error,
              ),
              obscureText: snapshotShowPassword.hasData
                  ? snapshotShowPassword.data
                  : true,
              onChanged: loginBloc.changePassword,
            );
          },
        );
      },
    );
  }
}
