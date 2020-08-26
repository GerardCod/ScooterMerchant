import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/order_reject_dialog.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderList extends StatelessWidget {
  const OrderList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderListBloc = Provider.orderBlocProviderOf(context);
    orderListBloc.changeOrderList(null);
    orderListBloc.getOrders();
    return _listStreamBuilder(orderListBloc);
  }

  Widget _listStreamBuilder(OrderBlocProvider orderBloc) {
    return StreamBuilder(
      stream: orderBloc.orderListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
        return snapshot.hasData
            ? _listBuilder(context, snapshot, bloc: orderBloc)
            : CircularProgressIndicator(
                backgroundColor: primaryColor,
                semanticsLabel: 'Cargando pedidos',
              );
      },
    );
  }

  Widget _listBuilder(
      BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot,
      {OrderBlocProvider bloc}) {
    return ListView.builder(
      itemCount: snapshot.hasData ? snapshot.data.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return _listItem(snapshot.data[index], context, bloc: bloc);
      },
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  Widget _listItem(OrderModel model, BuildContext context,
      {OrderBlocProvider bloc}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      borderOnForeground: true,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.person,
              size: 48.0,
            ),
            title: Text(model.customer.name, style: textStyleTitleListTile),
            subtitle: Text(DateTime.parse(model.orderDate).toLocal().toString(),
                style: textStyleSubtitleListTile),
          ),
          ListTile(
            title: Text(
              model.details[0].productName,
              style: textStyleWordDescListTile,
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => this._navigateToDetails(context, model),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                  child: Text('Aceptar', style: textStyleBtnComprar),
                  shape: radiusButtons,
                  color: primaryColor,
                  padding: paddingButtons,
                  onPressed: () => this._acceptOrder(model, bloc)),
              RaisedButton(
                  color: Colors.white,
                  shape: radiusButtons,
                  elevation: 0.0,
                  padding: paddingButtons,
                  child: Text('Rechazar', style: signinLogin),
                  onPressed: () => this._showRejectDialog(
                      model: model, context: context, bloc: bloc))
            ],
          )
        ],
      ),
      shadowColor: Color.fromRGBO(0, 0, 0, 0.75),
      elevation: 2.0,
    );
  }

  void _navigateToDetails(BuildContext context, OrderModel model) {
    Navigator.pushNamed(context, 'orderDetails', arguments: model);
  }

  void _acceptOrder(OrderModel model, OrderBlocProvider bloc) async {
    final Map<String, dynamic> response = await bloc.acceptOrder(model);
    if (response['ok']) {
      await bloc.getOrders();
    }
  }

  Future<void> _showRejectDialog(
      {OrderBlocProvider bloc, OrderModel model, BuildContext context}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return OrderRejectDialog(
            bloc: bloc,
            order: model,
          );
        });
  }
}
