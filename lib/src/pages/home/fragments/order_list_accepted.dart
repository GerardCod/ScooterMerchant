import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/cancel_order_dialog.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class OrderListAccepted extends StatelessWidget {
  const OrderListAccepted({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final size = MediaQuery.of(context).size;
    bloc.changeOrderList(null);
    bloc.getOrders(allOrders: true);
    return _listStreamBuilder(bloc, size);
  }

  Widget _listStreamBuilder(OrderBlocProvider bloc, Size size) {
    return StreamBuilder<List<OrderModel>>(
        stream: bloc.orderListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: _itemSkeleton(size),
              ),
            );
          }
          if (snapshot.data.length == 0) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No hay ningun pedido.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _listBuilder(context, snapshot, orderBloc: bloc);
        });
  }

  Widget _listBuilder(
      BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot,
      {OrderBlocProvider orderBloc}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _listItem(snapshot.data[index], context, orderBloc),
        childCount: snapshot.hasData ? snapshot.data.length : 0,
      ),
    );
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
          onPressed: () => this._orderReady(model, bloc),
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

  void _orderReady(OrderModel model, OrderBlocProvider bloc) async {
    final response = await bloc.orderReady(model);
    if (response['ok']) {
      bloc.getOrders(status: status['in_process'], inProcess: true);
    }
  }

  Widget _itemSkeleton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _listItemSkeleton()),
    );
  }

  List<Widget> _listItemSkeleton() {
    List listings = List<Widget>();
    for (int i = 0; i < 5; i++) {
      listings.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 150.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }
}
