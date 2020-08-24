import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        this.title,
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
  Size get preferredSize => Size.fromHeight(45.0);
}
