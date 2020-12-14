import 'package:flutter/material.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/pages/order_details/pick_up/delivery_pick_up_page.dart';
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
    // final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: _customAppBar(),
      body: _customBody(size, orderModel, context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.help_outline),
          backgroundColor: secondaryColor,
          onPressed: () => _displayBottomSheet(context, size)),
      // persistentFooterButtons: <Widget>[
      //   _showButtonsHelp(context, size),
      // ],
    );
  }

  void _displayBottomSheet(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: _showButtonsHelp(context, size),
          );
        });
  }

  Widget _customAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text('Detalles del pedido', style: txtStyleAppBar),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  Widget _customBody(Size size, OrderModel orderModel, BuildContext context) {
    return Stack(
      children: <Widget>[
        // _header(size),
        SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _cardInfo(orderModel, context),
            _cardProducts(orderModel),
            SizedBox(height: 100)
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
          SizedBox(height: 10),
          _showDelivery(context),
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
            width: 160,
            height: 35,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: _showColorStatus(),
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

  Color _showColorStatus() {
    if (orderModel.orderStatus.id == 7 || orderModel.orderStatus.id == 8) {
      return Colors.red;
    }
    if (orderModel.orderStatus.id == 6) {
      return Colors.green;
    }
    return Colors.orange;
  }

  Widget _informationDelivery(OrderModel orderModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            _imageDelivery(orderModel.deliveryMan.picture, context),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _nameDelivery(orderModel.deliveryMan.name),
                  Text('Scooter'),
                ],
              ),
            ),
          ],
        ),
        _callDelivery(orderModel.deliveryMan.phoneNumber)
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
    return Text(
      name,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _showDelivery(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Center(
        child: RaisedButton(
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                'Seguir repartidor  ',
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.map,
                color: Colors.white,
              )
            ],
          ),
          onPressed: orderModel.orderStatus.id != 6
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DeliveryPickUp(orderModel)))
              : null,
          color: secondaryColor,
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
          // Divider(),
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
    String quantity = product
        .menuOptions[indexMenuO].options[indexOption].quantity
        .toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('x$quantity ' +
            product.menuOptions[indexMenuO].options[indexOption].optionName),
        Text(_showPriceOption(product, indexMenuO, indexOption)),
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
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

  Widget _showButtonsHelp(BuildContext context, size) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '¿Tienes algún problema?',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Divider(),
              Text(
                'Puedes ',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                width: size.width * 0.6,
                child: RaisedButton(
                  color: primaryColor,
                  child: Text(
                    'Llamar al cliente',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () =>
                      launch("tel:${orderModel.customer.phoneNumber}"),
                ),
              ),
              Text(
                'o',
                style: TextStyle(fontSize: 18),
              ),
              Container(
                width: size.width * 0.6,
                child: RaisedButton(
                  color: secondaryColor,
                  child: Text('Llamar a la central',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () =>
                      launch("tel:${orderModel.stationObject.phoneNumber}"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
