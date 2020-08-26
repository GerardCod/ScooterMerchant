import 'package:flutter/material.dart';
import 'package:scootermerchant/src/widgets/appbar_widget.dart';

class AcceptedOrderDetailsPage extends StatelessWidget {
  const AcceptedOrderDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Accepted orders details'),
      ),
    );
  }
}
