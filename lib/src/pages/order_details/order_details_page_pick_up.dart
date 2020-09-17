import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPagePickUp extends StatelessWidget {
  // const OrderDetailsPage({Key key}) : super(key: key);
  final OrderModel orderModel;
  OrderDetailsPagePickUp(this.orderModel);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    // final OrderModel model = args['model'];
    // final String typeList = args['type'];
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: _customAppBar(),
      body: _customBody(size, orderModel, context),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      title: Text('Detalles del pedido', style: TextStyle(color: Colors.white)),
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
  }

  Widget _customBody(Size size, OrderModel orderModel, BuildContext context) {
    return Stack(
      children: <Widget>[
        _header(size),
        SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _cardInfo(orderModel, context),
            _cardProducts(orderModel),
          ],
        )),
      ],
    );
  }

  Widget _header(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.25,
      color: primaryColor,
    );
  }

  Widget _cardInfo(OrderModel orderModel, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10, bottom: 10),
      borderOnForeground: true,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      child: _bodyCardInfo(orderModel, context),
    );
  }

  Widget _bodyCardInfo(OrderModel orderModel, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _nameCustomer(orderModel),
          orderModel.indications != null
              ? _indications(orderModel)
              : Container(),
          SizedBox(height: 20),
          _orderStatus(orderModel),
          Divider(
            color: Colors.grey,
          ),
          _informationDelivery(orderModel, context),
        ],
      ),
    );
  }

  Widget _nameCustomer(OrderModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          model.qrCode,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: fontFamily,
          ),
        ),
        SizedBox(width: 20),
        Text(
          model.customer.name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _indications(OrderModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Indicaciones',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: fontFamily,
          ),
        ),
        Text(model.indications),
      ],
    );
  }

  Widget _orderStatus(OrderModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Estado del pedido',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: fontFamily,
            ),
          ),
          Container(
            width: 100,
            height: 35,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.orange,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                model.orderStatus.name,
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _informationDelivery(OrderModel orderModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            _imageDelivery(orderModel.deliveryMan.picture, context),
            _nameDelivery(orderModel.deliveryMan.name),
          ],
        ),
        Row(
          children: <Widget>[
            _callDelivery(orderModel.deliveryMan.phoneNumber),
          ],
        )
      ],
    );
  }

  Widget _imageDelivery(String picture, BuildContext context) {
    if (picture != null) {
      return GestureDetector(
        onTap: () => _showAnimation(context, picture),
        child: Hero(
          tag: 'animation-hero',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              color: Colors.grey,
              width: 40,
              height: 40,
              child: FadeInImage(
                  placeholder: AssetImage('assets/images/no_image.png'),
                  image: NetworkImage('$picture')),
            ),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: 30,
      backgroundColor: primaryColor,
    );
  }

  Widget _nameDelivery(String name) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _callDelivery(String phoneNumber) {
    return IconButton(
      icon: Icon(
        Icons.call,
        color: Colors.black,
      ),
      onPressed: () => launch("tel:${orderModel.deliveryMan.phoneNumber}"),
    );
  }

  Widget _cardProducts(OrderModel orderModel) {
    return Card(
      margin: EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
      borderOnForeground: true,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            _productList(orderModel),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: \u0024' + orderModel.orderPrice.toStringAsFixed(2),
                style: textStyleOrderDetailsSectionTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productList(OrderModel model) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.details.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              _itemProduct(model.details[index], index + 1),
              Divider(),
            ],
          ),
        );
      },
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
    );
  }

  Widget _itemProduct(Details product, int index) {
    return Column(
      children: <Widget>[
        _nameProduct(product, index),
        _descriptionProduct(product),
      ],
    );
  }

  Widget _nameProduct(Details product, int index) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            'x' + product.quantity.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.timer,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                ),
                TextSpan(
                  text: product.productName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        // Container(padding: EdgeInsets.only(top: 25, bottom: 25))
      ],
    );
  }

  Widget _descriptionProduct(Details product) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(flex: 7, child: _menuOptionsProduct(product)),
      ],
    );
  }

  Widget _menuOptionsProduct(Details product) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: product.menuOptions.length,
      itemBuilder: (BuildContext context, int indexMenuO) {
        return _itemMenu(product, indexMenuO);
      },
    );
  }

  Widget _itemMenu(Details product, int indexMenuO) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.menuOptions[indexMenuO].menuName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: product.menuOptions[indexMenuO].options.length,
            itemBuilder: (BuildContext context, int indexOption) {
              return _itemOption(product, indexMenuO, indexOption);
            },
          ),
        ],
      ),
    );
  }

  Widget _itemOption(Details product, int indexMenuO, indexOption) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(product.menuOptions[indexMenuO].options[indexOption].optionName),
        Text(_showPriceOption(product, indexMenuO, indexOption))
      ],
    );
  }

  String _showPriceOption(Details product, int indexMenuO, indexOption) {
    if (product.menuOptions[indexMenuO].options[indexOption].priceOption == 0) {
      return '';
    }
    return '\u0024' +
        product.menuOptions[indexMenuO].options[indexOption].priceOption
            .toStringAsFixed(2);
  }

  void _showAnimation(BuildContext context, String image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Hero(
              tag: "animation-hero",
              child: Image.network(image),
            ),
          ),
        ),
      ),
    );
  }
}
