import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
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
                        Text(formatDate(DateTime.parse(model.orderDate), [
                          dd,
                          '/',
                          mm,
                          '/',
                          yyyy,
                          ' ',
                          hh,
                          ':',
                          nn,
                          ' ',
                          am
                        ])),
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

  void _navigateToDetails(BuildContext context, OrderModel model) {
    print(typeList);
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
