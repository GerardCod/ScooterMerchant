import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/status_chip.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderCard extends StatelessWidget {
  final OrderModel model;
  final OrderBlocProvider bloc;
  final String typeList;
  const OrderCard({Key key, this.bloc, this.model, this.typeList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return Card(
      color: Colors.white,
      borderOnForeground: true,
      child: InkWell(
        onTap: () => this._navigateToDetails(context, model),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                typeList == 'history' ? _rowStatus(model) : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(model.customer.name,
                            style: textStyleTitleListTile),
                        Text(_dateConvert(model.orderDate.toString())),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 36.0,
                      color: Colors.grey[700],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      shadowColor: Color.fromRGBO(0, 0, 0, 0.75),
      elevation: 3.0,
    );
  }

  _dateConvert(String date) {
    String f;
    var now = DateTime.parse(date);
    return f = DateFormat.yMEd('es').add_jms().format(now).toString();
  }

  void _navigateToDetails(BuildContext context, OrderModel model) {
    Navigator.of(context).pushNamed('orderDetails',
        arguments: {'model': model, 'type': typeList});
  }

  Widget _rowStatus(OrderModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StatusChipWidget(
          statusId: model.orderStatus.id,
        ),
      ],
    );
  }
}
