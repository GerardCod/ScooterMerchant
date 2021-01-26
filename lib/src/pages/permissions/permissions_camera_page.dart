import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';

class PermissionCameraPage extends StatefulWidget {
  PermissionCameraPage({Key key}) : super(key: key);

  @override
  _PermissionCameraPageState createState() => _PermissionCameraPageState();
}

class _PermissionCameraPageState extends State<PermissionCameraPage> {
  MerchantPreferences _prefs = new MerchantPreferences();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // appBar: AppBar(
      //   brightness: Brightness.light,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _image(),
            SizedBox(height: 20),
            _message(),
            // _btnsActions()
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(),
            onPressed: () => _acceptPermission(),
            label: Text('Aceptar')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _image() {
    return Image.asset(
      'assets/images/permissions/qr_camera.png',
      fit: BoxFit.cover,
    );
  }

  Widget _message() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:20),
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 18.0,
          ),
          Text(
            "${_prefs.merchant.merchantName}, \n es necesario que nos concedas permisos para abrir tu cámara",
            style: TextStyle(
                fontSize: 23.0, fontFamily: 'arial', fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15.0,
          ),
          _subtitle(),
        ],
      ),
    );
  }

  Widget _subtitle() {
    return Text(
      'La utilizaremos para que puedas subir imágenes de tus productos',
      textAlign: TextAlign.center,
    );
  }

  Widget _btnsActions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_btnAccept()],
      ),
    );
  }

  Widget _btnAccept() {
    return Container(
      width: double.infinity,
      height: 45.0,
      child: RaisedButton(
        onPressed: () {
          _acceptPermission();
        },
        color: primaryColor,
        child: Text(
          'Aceptar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

/*   Widget _btnCancel() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context, false);
        },
        splashColor: Colors.white,
        elevation: 0,
        color: Colors.transparent,
        child: Text(
          'Ahora no',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  } */

  _acceptPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.camera].request();
    var status = statuses[Permission.camera];
    if (status == PermissionStatus.denied) {
      _scaffoldKey.currentState.showSnackBar(
          _createSnackBar(Colors.red, 'El permiso ha sido denegado'));
    }
    if (status == PermissionStatus.permanentlyDenied) {
      Navigator.pop(context, false);
    }

    if (status == PermissionStatus.granted) {
      Navigator.pop(context, true);
    }
  }

  _createSnackBar(Color color, String message) {
    return SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color);
  }
}
