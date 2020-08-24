import 'package:flutter/material.dart';
import 'package:scootermerchant/utilities/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_home_screen), title: Text('Entrantes')),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood), title: Text('En curso')),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), title: Text('Historial'))
        ]);
  }
}
