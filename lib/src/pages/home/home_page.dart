import 'package:flutter/material.dart';
import 'package:scootermerchant/src/pages/home/order_list.dart';
import 'package:scootermerchant/src/widgets/appbar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'SCOOTER',
      ),
      body: OrderList(),
    );
  }
}
