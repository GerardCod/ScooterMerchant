import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class ChangeProductPage extends StatelessWidget {
  const ChangeProductPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de productos',
          style: textStyleBtnComprar,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }
}
