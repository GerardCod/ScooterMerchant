import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/cancel_order_dialog.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderListAccepted extends StatelessWidget {
  const OrderListAccepted({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    bloc.changeOrderList(null);
    bloc.getOrders(status: status['in_process'], inProcess: true);
    return _listStreamBuilder(bloc);
  }

  Widget _listStreamBuilder(OrderBlocProvider bloc) {
    return StreamBuilder(
        stream: bloc.orderListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          return snapshot.hasData
              ? _listBuilder(context, snapshot, orderBloc: bloc)
              : CircularProgressIndicator(
                  backgroundColor: primaryColor,
                  semanticsLabel: 'Cargando pedidos',
                );
        });
  }

  Widget _listBuilder(
      BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot,
      {OrderBlocProvider orderBloc}) {
    return ListView.builder(
        itemCount: snapshot.hasData ? snapshot.data.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return _listItem(snapshot.data[index], context, orderBloc);
        });
  }

  Widget _listItem(
      OrderModel model, BuildContext context, OrderBlocProvider bloc) {
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
            onTap: () => this._navigateToDetails(model, context),
          ),
          _actions(model, bloc, context: context)
        ],
      ),
    );
  }

  Widget _actions(OrderModel model, OrderBlocProvider bloc,
      {BuildContext context}) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        RaisedButton(
          child: Text(
            'Terminado',
            style: textStyleBtnComprar,
          ),
          padding: paddingButtons,
          shape: radiusButtons,
          color: primaryColor,
          onPressed: () {},
        ),
        FlatButton(
          child: Text(
            'Cancelar',
            style: signinLogin,
          ),
          padding: paddingButtons,
          shape: radiusButtons,
          color: Colors.white,
          onPressed: () => this
              ._showCancelDialog(bloc: bloc, model: model, context: context),
        ),
      ],
    );
  }

  void _navigateToDetails(OrderModel model, BuildContext context) {
    Navigator.of(context).pushNamed('acceptedOrderDetails', arguments: model);
  }

  Future<void> _showCancelDialog(
      {OrderModel model, OrderBlocProvider bloc, BuildContext context}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CancelOrderDialog(
              bloc: bloc,
              model: model,
            ));
  }
}
