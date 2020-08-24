import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderList extends StatelessWidget {
  const OrderList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderListBloc = Provider.orderBlocProviderOf(context);
    orderListBloc.getOrders();
    return _listStreamBuilder(orderListBloc);
  }

  Widget _listStreamBuilder(OrderBlocProvider orderBloc) {
    return StreamBuilder(
      stream: orderBloc.orderListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
        return _listBuilder(snapshot);
      },
    );
  }

  Widget _listBuilder(AsyncSnapshot<List<OrderModel>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.hasData ? snapshot.data.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return _listItem(snapshot.data[index]);
      },
    );
  }

  Widget _listItem(OrderModel model) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Text(model.customer.name, style: textStyleTitleListTile),
            subtitle: Text(model.orderDate, style: textStyleSubtitleListTile),
          ),
        ],
      ),
      shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
    );
  }
}
