import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/order_reject_dialog.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final OrderModel args = ModalRoute.of(context).settings.arguments;
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del pedido', style: textStyleBtnComprar),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: <Widget>[
          _header(size),
          SingleChildScrollView(
            child: _containerInfo(
                size: size, bloc: bloc, context: context, model: args),
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
          gradient: LinearGradient(
              colors: <Color>[primaryColor, primaryColorSecondary]),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0))),
    );
  }

  Widget _containerInfo(
      {Size size,
      OrderModel model,
      OrderBlocProvider bloc,
      BuildContext context}) {
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
              _containerHeader(model),
              SizedBox(
                height: 16.0,
              ),
              Text('Dirección de entrega',
                  style: textStyleOrderDetailsSectionTitle),
              _address(model),
              Text(
                'Lista de productos',
                style: textStyleOrderDetailsSectionTitle,
              ),
              _productList(model),
              Text(
                'Total: ${model.totalOrder} pesos',
                style: textStyleOrderDetailsSectionTitle,
              ),
              _actions(context: context, model: model, provider: bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerHeader(OrderModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.person,
          size: sizeIconsDetails,
        ),
        SizedBox(
          width: 32.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              model.customer.name,
              style: textStyleTitleListTile,
            ),
            Text(
                formatDate(DateTime.parse(model.orderDate),
                    [dd, '/', mm, '/', yyyy, '  ', hh, ':', nn, ' ', am]),
                style: textStyleSubtitleListTile)
          ],
        ),
      ],
    );
  }

  Widget _productList(OrderModel model) {
    return ListView.builder(
      itemCount: model.details.length,
      itemBuilder: (BuildContext context, int index) {
        return _product(model.details[index]);
      },
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  Widget _product(Details product) {
    return ListTile(
      title: Text(product.productName, style: textStyleOrderDetailsText),
      trailing: Text('x${product.quantity}', style: textStyleOrderDetailsText),
    );
  }

  Widget _address(OrderModel orderModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Text(orderModel.toAddress.fullAddress,
          style: textStyleOrderDetailsText),
    );
  }

  Widget _actions(
      {OrderBlocProvider provider, OrderModel model, BuildContext context}) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            color: primaryColor,
            child: Text('Aceptar', style: textStyleBtnComprar),
            onPressed: () => this._acceptOrder(model, provider, context)),
        RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          // onPressed: () => this._showRejectDialog(
          //     bloc: provider, context: context, model: model),
          color: Colors.white,
          elevation: 0.0,
          child: Text(
            'Cancelar',
            style: signinLogin,
          ),
        )
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

  // Future<void> _showRejectDialog(
  //     {OrderBlocProvider bloc, OrderModel model, BuildContext context}) async {
  //   return await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return OrderRejectDialog(
  //           bloc: bloc,
  //           order: model,
  //         );
  //       });
  // }

  void _showSnackBar(BuildContext context, String text) {
    final SnackBar snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
