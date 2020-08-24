import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class Header extends StatelessWidget {
  const Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[primaryColor, secondaryColor],
          ),
          borderRadius: BorderRadius.all(Radius.circular(40.0))),
    );
  }
}
