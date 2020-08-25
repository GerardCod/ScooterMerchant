import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text(
        'SCOOTER',
        style: textStyleForAppBar,
      ),
      actions: <Widget>[
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.0);
}
