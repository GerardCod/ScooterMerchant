import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/pages/notification_order_details_page_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/utilities/constants.dart';

class NotificationOrderDetailsPage extends StatelessWidget {
  OrderModel orderModel;
  NotificationOrderDetailsPageBloc notificationBloc;
  @override
  Widget build(BuildContext context) {
    notificationBloc = Provider.notificationOrderDetailsPageBloc(context);
    // Obtener el orderId de la orden, viene del main.dart
    final orderId = ModalRoute.of(context).settings.arguments;
    // Obtener la informacion que se utilizo en bloc de la orden utilizando el orderId que viene de la push notificaiton
    notificationBloc.getOrder(orderId: orderId);
    final Size size = MediaQuery.of(context).size;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: _customAppBar(),
      body: _customBody(size, orderId, _scaffoldKey),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        'Detalles del pedido',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _customBody(
      Size size, String orderId, GlobalKey<ScaffoldState> scaffoldKey) {
    return Stack(
      children: <Widget>[
        _background(size),
        StreamBuilder<OrderModel>(
          stream: notificationBloc.orderStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _containerInfo(
                  size, notificationBloc, context, orderId, scaffoldKey);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Widget _background(Size size) {
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
      Size size,
      NotificationOrderDetailsPageBloc bloc,
      BuildContext context,
      String orderId,
      GlobalKey<ScaffoldState> scaffoldKey) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        borderOnForeground: true,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: _bodyCardInfo(bloc, orderId, context, scaffoldKey),
      ),
    );
  }

  Widget _bodyCardInfo(NotificationOrderDetailsPageBloc bloc, String orderId,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _nameCustomer(bloc),
          Divider(
            color: Colors.grey,
          ),
          _productList(bloc),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: \u0024' + bloc.order.orderPrice.toStringAsFixed(2),
              style: textStyleOrderDetailsSectionTitle,
            ),
          ),
          SizedBox(height: 40),
          _actionButtons(bloc, orderId, context, scaffoldKey),
        ],
      ),
    );
  }

  Widget _nameCustomer(NotificationOrderDetailsPageBloc bloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          bloc.order.qrCode != null ? bloc.order.qrCode : '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: fontFamily,
          ),
        ),
        SizedBox(width: 20),
        Text(
          bloc.order.customer.name != null ? bloc.order.customer.name : '',
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

  Widget _productList(NotificationOrderDetailsPageBloc bloc) {
    return StreamBuilder<List<Details>>(
      stream: bloc.detailsListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      _itemProduct(snapshot.data[index], bloc, index + 1),
                      Divider(),
                    ],
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
            shrinkWrap: true,
            // scrollDirection: Axis.vertical,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _itemProduct(
      Details product, NotificationOrderDetailsPageBloc bloc, index) {
    return Column(
      children: <Widget>[
        _nameProduct(product, bloc, index),
        _descriptionProduct(product),
      ],
    );
  }

  Widget _nameProduct(
      Details product, NotificationOrderDetailsPageBloc bloc, index) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            product.quantity.toString(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(product.menuOptions[indexMenuO].options[indexOption].optionName),
        Text(
          '\u0024' +
              product.menuOptions[indexMenuO].options[indexOption].priceOption
                  .toStringAsFixed(2),
        )
      ],
    );
  }

  Widget _actionButtons(NotificationOrderDetailsPageBloc bloc, String orderId,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: _buttonAccept(bloc, context, scaffoldKey),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
          child: _buttonReject(bloc, context, scaffoldKey),
        )
      ],
    );
  }

  Widget _buttonAccept(NotificationOrderDetailsPageBloc bloc,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
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
      onPressed: () => _onPressedButtonAccept(bloc, context, scaffoldKey),
    );
  }

  void _onPressedButtonAccept(NotificationOrderDetailsPageBloc bloc,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
    Map<String, dynamic> response = await bloc.acceptOrder();
    if (response['ok']) {
      scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.green, response['message']))
          .closed
          .then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('homePage'));
      });
    } else {
      scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.red, response['message']));
    }
  }

  Widget _buttonReject(NotificationOrderDetailsPageBloc bloc,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return RaisedButton(
      child: Text('Rechazar',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: secondaryColor)),
      color: Colors.white,
      onPressed: () => _showAlert(context, bloc, scaffoldKey),
    );
  }

  void _showAlert(BuildContext context, NotificationOrderDetailsPageBloc bloc,
      GlobalKey<ScaffoldState> scaffoldKey) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Wrap(
            children: <Widget>[
              Text(
                'Confirmación de rechazo',
                style: textStyleOrderDetailsSectionTitle,
              ),
              Divider()
            ],
          ),
          // elevation: 10.0,
          content: _dialogContent(bloc),
          actions: <Widget>[
            _buttonCancel(context),
            _buttonRejection(bloc, context, scaffoldKey)
          ],
        );
      },
    );
  }

  Widget _dialogContent(NotificationOrderDetailsPageBloc bloc) {
    return Wrap(
      children: <Widget>[
        Text(
          '¿En verdad quieres rechazar este pedido?',
          style: textStyleTitleListTile,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Escribe un mensaje para que ${bloc.order.customer.name} sepa por qué rechazaste su pedido',
            style: textStyleSubtitleListTile,
          ),
        ),
        _textFieldReasonRejection(bloc),
      ],
    );
  }

  Widget _textFieldReasonRejection(NotificationOrderDetailsPageBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.reasonRejectionStream,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Escribe el mensaje',
            contentPadding: EdgeInsets.all(16.0),
            errorText: snapshot.error,
          ),
          onChanged: bloc.changeReasonRejection,
        );
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

  Widget _buttonRejection(NotificationOrderDetailsPageBloc bloc,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return StreamBuilder<String>(
        stream: bloc.reasonRejectionStream,
        builder: (context, snapshot) {
          return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                    color: bloc.reasonRejection.length == 0
                        ? Colors.grey
                        : primaryColor),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Aceptar',
                    style: TextStyle(
                        color: bloc.reasonRejection.length == 0
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
              onPressed: bloc.reasonRejection == null ||
                      bloc.reasonRejection.length == 0
                  ? null
                  : () => _buttonRejectPressed(bloc, context, scaffoldKey));
        });
  }

  void _buttonRejectPressed(NotificationOrderDetailsPageBloc bloc,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async {
    Map<String, dynamic> response =
        await bloc.rejectOrder(bloc.reasonRejection);
    if (response['ok']) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('homePage'));
    } else {
      Navigator.pop(context);
      scaffoldKey.currentState
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
      duration: Duration(seconds: 3),
      backgroundColor: color,
    );
  }
}
