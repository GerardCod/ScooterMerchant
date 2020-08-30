import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/cancel_order_dialog.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedOrderDetailsPage extends StatelessWidget {
  const AcceptedOrderDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final OrderModel args = ModalRoute.of(context).settings.arguments;
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del pedido', style: textStyleBtnComprar),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          _header(size),
          _containerInfo(model: args, bloc: bloc, context: context)
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
      {OrderModel model, OrderBlocProvider bloc, BuildContext context}) {
    return SingleChildScrollView(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _cardHeader(model),
              SizedBox(
                height: 16.0,
              ),
              _sectionTitle('Dirección de entrega'),
              _address(model),
              _sectionTitle('Lista de productos'),
              _productList(model),
              _sectionTitle('Total: ${model.totalOrder} pesos'),
              _actions(model, bloc, context),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
        shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
        elevation: 10.0,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text, style: textStyleOrderDetailsSectionTitle);
  }

  Widget _cardHeader(OrderModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          Icons.person,
          size: sizeIconsDetails,
        ),
        SizedBox(
          width: 6.0,
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
                style: textStyleSubtitleListTile),
          ],
        ),
        IconButton(
          icon: Icon(Icons.call, size: sizeIconsDetails),
          onPressed: () => this._launchCall(model.customer.phoneNumber),
        )
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

  Widget _address(OrderModel model) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(model.toAddress.fullAddress),
    );
  }

  Widget _actions(
      OrderModel model, OrderBlocProvider bloc, BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () => this._orderReady(model, bloc, context),
          child: Text('Terminado', style: textStyleBtnComprar),
          shape: radiusButtons,
          padding: paddingButtons,
          color: primaryColor,
        ),
        FlatButton(
          child: Text(
            'Cancelar',
            style: signinLogin,
          ),
          shape: radiusButtons,
          color: Colors.white,
          padding: paddingButtons,
          onPressed: () => this._showCancelDialog(model, bloc, context),
        ),
      ],
    );
  }

  void _orderReady(
      OrderModel model, OrderBlocProvider bloc, BuildContext context) async {
    final response = await bloc.orderFinshed(model);
    if (response['ok']) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showCancelDialog(
      OrderModel model, OrderBlocProvider bloc, BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CancelOrderDialog(
              model: model,
              bloc: bloc,
            ));
  }

  void _launchCall(String phoneNumber) async {
    final call = 'tel:$phoneNumber';

    if (await canLaunch(call)) {
      await launch(call);
    } else {
      throw 'No se puede realizar la llamada al número $phoneNumber';
    }
  }
}
