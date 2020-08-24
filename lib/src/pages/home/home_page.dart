import 'package:flutter/material.dart';
import 'package:scootermerchant/src/pages/home/order_list.dart';
import 'package:scootermerchant/src/widgets/appbar_widget.dart';
import 'package:scootermerchant/src/widgets/bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: OrderList(),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
