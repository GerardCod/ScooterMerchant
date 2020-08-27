import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final double height;
  // CustomAppBar({@required this.height});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0.0,
      title: Text(
        'SCOOTER',
        style: textStyleForAppBar,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
