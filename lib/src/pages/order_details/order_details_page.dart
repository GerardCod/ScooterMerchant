import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatelessWidget {
  // const OrderDetailsPage({Key key}) : super(key: key);
  OrderModel orderModel;
  OrderDetailsPage(this.orderModel);
  Size size;
  OrderBlocProvider bloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    bloc = Provider.orderBlocProviderOf(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text('Detalles del pedido', style: txtStyleAppBar),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: <Widget>[
          // _header(size),
          SingleChildScrollView(
            child: Column(
              children: [
                _containerInfo(context),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.help_outline),
          backgroundColor: secondaryColor,
          onPressed: () => _displayBottomSheet(context)),
    );
  }

  void _displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: size.height * 0.25,
            child: _showButtonsHelp(context),
          );
        });
  }

  Widget _showButtonsHelp(BuildContext context) {
    return Padding(
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
              onPressed: () => launch("tel:${orderModel.customer.phoneNumber}"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerInfo(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        borderOnForeground: true,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: _bodyCardInfo(context),
      ),
    );
  }

  Widget _bodyCardInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _nameCustomer(),
          Divider(
            color: Colors.grey,
          ),
          orderModel.indications != null ? _indications() : Container(),
          _paymentMethod(),
          SizedBox(height: 20),
          _productList(),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: \u0024' + orderModel.orderPrice.toStringAsFixed(2),
              style: textStyleOrderDetailsSectionTitle,
            ),
          ),
          SizedBox(height: 40),
          _showActions(context: context),
          Divider(),
          _showReasonRejection(),
        ],
      ),
    );
  }

  Widget _showActions({BuildContext context}) {
    if (orderModel.orderStatus.id == 14) {
      return _actionButtons(context);
    } else if (orderModel.orderStatus.id == 15) {
      return _actionButtonsInProcess(context);
    }
    return Container();
  }

  Widget _showReasonRejection() {
    if (orderModel.id == 7 && orderModel.reasonRejection != null) {
      return Column(
        children: <Widget>[
          Text('Razon de rechazo o cancelacion'),
          Text(orderModel.reasonRejection)
        ],
      );
    }
    if (orderModel.id == 7 && orderModel.reasonRejection != null) {
      return Column(
        children: <Widget>[
          Text('Razon de rechazo'),
          Text(orderModel.reasonRejection)
        ],
      );
    }
    return Container();
  }

  Widget _nameCustomer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          orderModel.qrCode,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        SizedBox(width: 20),
        Text(
          orderModel.customer.name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _indications() {
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
        Text(orderModel.indications),
      ],
    );
  }

  Widget _paymentMethod() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Método de pago',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        SizedBox(height: 5),
        orderModel.isPaymentOnline
            ? Row(
                children: [
                  Icon(Icons.credit_card_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Pagado con tarjeta',
                      style: TextStyle(fontSize: 17, color: Colors.green))
                ],
              )
            : Row(
                children: [
                  Image.asset('assets/images/payment/cash_payment.png',
                      height: 20, width: 20),
                  SizedBox(width: 12),
                  Text('Pago en efectivo', style: TextStyle(fontSize: 17))
                ],
              )
      ],
    );
  }

  Widget _productList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: orderModel.details.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              _itemProduct(orderModel.details[index], index + 1),
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
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '\$' + priceProduct(product),
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String priceProduct(Details product) {
    double price = product.productPrice * product.quantity;
    return price.toStringAsFixed(2);
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
      // scrollDirection: Axis.vertical,
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
    String quantity = product
        .menuOptions[indexMenuO].options[indexOption].quantity
        .toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('x$quantity ' +
            product.menuOptions[indexMenuO].options[indexOption].optionName),
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

  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: _buttonAccept(context),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
          child: _buttonReject(context),
        )
      ],
    );
  }

  Widget _buttonAccept(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: secondaryColor),
      ),
      color: secondaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Aceptar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<bool>(
            stream: bloc.loaderAcceptOrderStream,
            builder: (context, snapshot) {
              return Visibility(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                visible: snapshot.hasData && bloc.loaderAcceptOrder == true,
              );
            },
          )
        ],
      ),
      onPressed: () => _onPressedButtonAccept(context),
    );
  }

  void _onPressedButtonAccept(
    BuildContext context,
  ) async {
    Map<String, dynamic> response = await bloc.acceptOrder(orderModel);
    if (response['ok']) {
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.green, response['message']))
          .closed
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('homePage'));
      });
      bloc.getOrders(status: '14', ordering: 'created');
    } else {
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.red, response['message']))
          .closed
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('homePage'));
      });
    }
  }

  Widget _buttonReject(
    BuildContext context,
  ) {
    return RaisedButton(
      child: Text('Rechazar',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: secondaryColor)),
      color: Colors.white,
      onPressed: () => _showAlert(context),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Wrap(
            children: <Widget>[
              Text(
                orderModel.inProcess == true
                    ? 'Confirmación de cancelación'
                    : 'Confirmación de rechazo',
                style: textStyleOrderDetailsSectionTitle,
              ),
              // Divider()
            ],
          ),
          // elevation: 10.0,
          content:
              // Text('Something'),
              _dialogContent(),
          actions: <Widget>[
            _buttonCancel(context),
            orderModel.inProcess == true
                ? _buttonCancelation(context)
                : _buttonRejection(context)
          ],
        );
      },
    );
  }

  Widget _dialogContent() {
    return SingleChildScrollView(
      child: Wrap(
        children: <Widget>[
          // Text(
          //   orderModel.inProcess == true
          //       ? '¿En verdad quieres cancelar este pedido?'
          //       : '¿En verdad quieres rechazar este pedido?',
          //   style: textStyleTitleListTile,
          // ),
          Text(
            _getMessage(),
            style: textStyleSubtitleListTile,
          ),
          Text(
              orderModel.isPaymentOnline
                  ? 'Si rechazas o cancelas muchos pedidos serás sancionado.'
                  : '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 50),
          _textFieldReasonRejection(),
        ],
      ),
    );
  }

  String _getMessage() {
    if (orderModel.inProcess) {
      return 'Escribe un mensaje para que ${orderModel.customer.name} sepa por qué cancelaste su pedido';
    }
    return 'Escribe un mensaje para que ${orderModel.customer.name} sepa por qué rechazaste su pedido';
  }

  Widget _textFieldReasonRejection() {
    return StreamBuilder<String>(
      stream: orderModel.inProcess == true
          ? bloc.cancelReasonStream
          : bloc.rejectReasonStream,
      builder: (context, snapshot) {
        return TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Escribe el mensaje',
              contentPadding: EdgeInsets.all(16.0),
              errorText: snapshot.error,
            ),
            onChanged: orderModel.inProcess == true
                ? bloc.changeCancelReason
                : bloc.changeRejectReason);
      },
    );
  }

  Widget _buttonCancel(BuildContext context) {
    return RaisedButton(
      onPressed: () => Navigator.of(context).pop(),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: primaryColor)),
      child: Text('Cancelar', style: TextStyle(color: Colors.white)),
      // shape: radiusButtons,
      color: primaryColor,
      padding: paddingButtons,
    );
  }

  Widget _buttonRejection(BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.rejectReasonStream,
        builder: (context, snapshot) {
          return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                    color: bloc.rejectReason == null ||
                            bloc.rejectReason.length == 0
                        ? Colors.grey
                        : primaryColor),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Aceptar',
                    style: TextStyle(
                        color: bloc.rejectReason == null ||
                                bloc.rejectReason.length == 0
                            ? Colors.grey
                            : primaryColor),
                  ),
                  StreamBuilder<bool>(
                    stream: bloc.loaderRejectOrderStream,
                    builder: (context, snapshot) {
                      return Visibility(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        visible:
                            snapshot.hasData && bloc.loaderRejectOrder == true,
                      );
                    },
                  )
                ],
              ),
              color: Colors.white,
              padding: paddingButtons,
              onPressed:
                  bloc.rejectReason == null || bloc.rejectReason.length == 0
                      ? null
                      : () => _buttonRejectPressed(context));
        });
  }

  void _buttonRejectPressed(
    BuildContext context,
  ) async {
    Map<String, dynamic> response =
        await bloc.rejectOrder(bloc.rejectReason, orderModel);
    if (response['ok']) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('homePage'));
    } else {
      Navigator.pop(context);
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.green, response['message']))
          .closed
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('homePage'));
      });
    }
  }

  _createSnackBar(Color color, String message) {
    return SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: color,
    );
  }

  // void _showSnackBar(BuildContext context, String text) {
  //   final SnackBar snackBar = SnackBar(content: Text(text));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  //  InProcess

  Widget _actionButtonsInProcess(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: _buttonFinished(context),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
          child: _buttonCancelOrder(context),
        )
      ],
    );
  }

  Widget _buttonFinished(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: secondaryColor),
      ),
      color: secondaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Terminado',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          StreamBuilder<bool>(
            stream: bloc.loaderFinishedOrderStream,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.hasData && snapshot.data == true,
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            },
          )
        ],
      ),
      onPressed: () => _onPressedButtonFinished(context),
    );
  }

  void _onPressedButtonFinished(BuildContext context) async {
    Map<String, dynamic> response = await bloc.orderFinshed(orderModel);
    if (response['ok']) {
      // print(response);
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.green, response['message']))
          .closed
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('homePage'));
      });
    } else {
      // print(response);
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.red, response['message']));
    }
  }

  Widget _buttonCancelOrder(BuildContext context) {
    return RaisedButton(
      child: Text(
        'Cancelar',
        style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: secondaryColor),
      ),
      color: Colors.white,
      onPressed: () => _showAlert(context),
    );
  }

  Widget _buttonCancelation(BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.cancelReasonStream,
        builder: (context, snapshot) {
          return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                    color: bloc.cancelReason == null ||
                            bloc.cancelReason.length == 0
                        ? Colors.grey
                        : primaryColor),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Aceptar',
                    style: TextStyle(
                        color: bloc.cancelReason == null ||
                                bloc.cancelReason.length == 0
                            ? Colors.grey
                            : primaryColor),
                  ),
                  StreamBuilder<bool>(
                    stream: bloc.loaderCancelOrderStream,
                    builder: (context, snapshot) {
                      return Visibility(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        visible:
                            snapshot.hasData && bloc.loaderCancelOrder == true,
                      );
                    },
                  )
                ],
              ),
              color: Colors.white,
              padding: paddingButtons,
              onPressed:
                  bloc.cancelReason == null || bloc.cancelReason.length == 0
                      ? null
                      : () => _buttonCancelPressed(context));
        });
  }

  void _buttonCancelPressed(BuildContext context) async {
    Map<String, dynamic> response =
        await bloc.cancelOrder(orderModel, bloc.cancelReason);
    if (response['ok']) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('homePage'));
    } else {
      print(response['message']);
      showAlert(
          context, 'Error, comunicate con el soporte', response['message']);
    }
  }
}
