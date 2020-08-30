import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/pages/notification_order_details_page_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/order_reject_dialog.dart';
import 'package:scootermerchant/utilities/constants.dart';

import '../../../utilities/constants.dart';
import '../../blocs/order_bloc_provider.dart';
import '../../blocs/provider.dart';
import '../../models/order_model.dart';

class NotificationOrderDetailsPage extends StatelessWidget {
  OrderModel orderModel;
  NotificationOrderDetailsPageBloc notificationBloc;
  @override
  Widget build(BuildContext context) {
    notificationBloc = Provider.notificationOrderDetailsPageBloc(context);
    // Obtener el orderId de la orden, viene del main.dart
    final orderId = ModalRoute.of(context).settings.arguments;
    // print('Argument from Notification');
    // print(orderId);
    // Obtener la informacion que se utilizo en bloc de la orden utilizando el orderId que viene de la push notificaiton
    notificationBloc.getOrder(orderId: orderId);
    // _getDataOrder(orderId);
    final Size size = MediaQuery.of(context).size;
    // final OrderModel args = ModalRoute.of(context).settings.arguments;
    // final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del pedido',
          style: textStyleForAppBar,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          _header(size),
          // Text('NotificationOrderDetailsPage'),
          StreamBuilder<OrderModel>(
            stream: notificationBloc.orderStream,
            builder: (context, snapshot) {
              return _containerInfo(size, notificationBloc, context);
            },
          ),
        ],
      ),
    );
  }

  Widget _header(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.25,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
    );
  }

  Widget _containerInfo(
      Size size, NotificationOrderDetailsPageBloc bloc, BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        borderOnForeground: true,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _nameCustomer(bloc),
              SizedBox(
                height: 16.0,
              ),
              _toAddress(bloc),
              Text(
                'Lista de productos',
                style: textStyleOrderDetailsSectionTitle,
              ),
              _productList(bloc),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Total: \u0024' + bloc.order.totalOrder.toStringAsFixed(2),
                  style: textStyleOrderDetailsSectionTitle,
                ),
              ),
              SizedBox(height: 40),
              _actionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameCustomer(NotificationOrderDetailsPageBloc bloc) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          bloc.order.customer.name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        Text(
          'Nombre del cliente',
          style: textStyleTitleListTile,
        ),
      ],

      // subtitle: Text(DateTime.parse(model.orderDate).toString(),
      //     style: textStyleSubtitleListTile),
    );
  }

  Widget _toAddress(NotificationOrderDetailsPageBloc bloc) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Text(bloc.order.toAddress.fullAddress,
          style: textStyleOrderDetailsText),
    );
  }

  Widget _productList(NotificationOrderDetailsPageBloc bloc) {
    return StreamBuilder<List<Details>>(
      stream: bloc.detailsListStream,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return _itemProduct(snapshot.data[index]);
          },
          shrinkWrap: true,
          // scrollDirection: Axis.vertical,
        );
      },
    );
  }

  Widget _itemProduct(Details product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          product.productName,
          style: textStyleOrderDetailsText,
        ),
        Text('x${product.quantity}'),
        Container(padding: EdgeInsets.only(top: 25, bottom: 25))
      ],
    );

    // ListTile(
    //   title: Text(product.productName, style: textStyleOrderDetailsText),
    //   trailing: Text('x${product.quantity}', style: textStyleOrderDetailsText),
    // );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // RaisedButton(
        //   color: Colors.white,
        //   shape: radiusButtons,
        //   elevation: 0.0,
        //   padding: paddingButtons,
        //   child: Text('Rechazar', style: signinLogin),
        //   onPressed: () => this._showRejectDialog(),
        // )
        RaisedButton(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: secondaryColor)),
          color: Colors.white,
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {},
        ),
        RaisedButton(
          child: Text('Rechazar', style: textStyleBtnComprar),
          shape: radiusButtons,
          color: primaryColor,
          padding: paddingButtons,
          onPressed: () {},
        ),
      ],
    );
  }

  void _acceptOrder(
      OrderModel model, OrderBlocProvider bloc, BuildContext context) async {
    final Map<String, dynamic> response = await bloc.acceptOrder(model);
    if (response['ok']) {
      _showSnackBar(context, 'El pedido ha sido aceptado');
    } else {
      _showSnackBar(context, 'Ocurrió un error al aceptar el pedido');
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

  void _showSnackBar(BuildContext context, String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // void _getDataOrder(String orderId, OrderBlocProvider bloc) async {
  //   Map<String, dynamic> response = await bloc.getOrder(orderId);
  // }
}
