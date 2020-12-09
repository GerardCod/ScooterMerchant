import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/src/pages/login_page/login_page.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionPage extends StatelessWidget {
  // const NewObligatoryVersionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pref = MerchantPreferences();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: _customBody(size, context, _pref),
    );
  }

  _customBody(Size size, BuildContext context, _pref) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'assets/icon/icon_launcher.jpg',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 7,
                      child: Text(
                        'Los Pedidos - Comercios, necesita una actualización.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 35, right: 35),
                        child: Text(
                          'Para seguir usando esta aplicación, se recomienda descargar la última versión.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25),
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(left: 35, right: 35),
                  child: RaisedButton(
                    color: primaryColor,
                    child: Text(
                      'Actualizar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      var url = Platform.isIOS
                          ? 'https://apps.apple.com/us/app/id1530703738'
                          : 'https://play.google.com/store/apps/details?id=com.devopsti.scooter.app';
                      launch(url);
                    },
                  ),
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(left: 35, right: 35),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: primaryColor)),
                      color: Colors.white,
                      child: Text(
                        'En otro momento',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _goToPage(context, _pref)),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            child: Platform.isAndroid
                ? Image.asset('assets/images/logos/play_store_logo.png')
                : Image.asset('assets/images/logos/app_store_logo.png'),
          ),
        )
      ],
    );
  }

  _goToPage(BuildContext context, MerchantPreferences pref) {
    if (pref.access == null) {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        ModalRoute.withName('/'),
      );
    }
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      ModalRoute.withName('homePage'),
    );
  }
}
