import 'package:flutter/material.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';

class Header extends StatelessWidget {
  final MerchantPreferences _prefs = MerchantPreferences();
  Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0)),
        image: DecorationImage(
            image: NetworkImage(this._prefs.merchant.picture),
            fit: BoxFit.cover),
      ),
      child: Center(
        child: Text(
          _prefs.merchant.merchantName,
          style: TextStyle(
              fontSize: 30.0, color: Colors.white, fontFamily: fontFamily),
        ),
      ),
    );
  }
}
