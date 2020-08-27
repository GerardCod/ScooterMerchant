import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/appbar_widget.dart';
import 'package:scootermerchant/utilities/constants.dart';

class AcceptedOrderDetailsPage extends StatelessWidget {
  const AcceptedOrderDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final OrderModel args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: <Widget>[_header(size), _containerInfo(model: args)],
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.person,
          size: 48.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              model.customer.name,
              style: textStyleTitleListTile,
            ),
            Text(DateTime.parse(model.orderDate).toString(),
                style: textStyleSubtitleListTile),
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

  Widget _address(OrderModel model) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(model.toAddress.fullAddress),
    );
  }
}
