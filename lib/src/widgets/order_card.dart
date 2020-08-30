import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderCard extends StatelessWidget {
  final OrderModel model;
  final OrderBlocProvider bloc;
  const OrderCard({Key key, this.bloc, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () => this._navigateToDetails(context, model),
            title: Text(model.customer.name, style: textStyleTitleListTile),
            subtitle: Text(
                formatDate(DateTime.parse(model.orderDate),
                    [dd, '/', mm, '/', yyyy, '  ', hh, ':', nn, ' ', am]),
                style: textStyleSubtitleListTile),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      shadowColor: Color.fromRGBO(0, 0, 0, 0.75),
      elevation: 2.0,
    );
    ;
  }

  void _navigateToDetails(BuildContext context, OrderModel model) {
    Navigator.of(context).pushNamed('orderDetails', arguments: model);
  }
}
