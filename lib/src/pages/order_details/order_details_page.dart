import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final OrderModel args = ModalRoute.of(context).settings.arguments;
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:
            Text('Detalles del pedido', style: TextStyle(color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: <Widget>[
          _header(size),
          SingleChildScrollView(
            child: _containerInfo(
                size: size,
                bloc: bloc,
                context: context,
                model: args,
                scaffoldKey: _scaffoldKey),
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
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey}) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        borderOnForeground: true,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: _bodyCardInfo(model, scaffoldKey, bloc, context),
      ),
    );
  }

  Widget _bodyCardInfo(OrderModel model, GlobalKey<ScaffoldState> scaffoldKey,
      OrderBlocProvider bloc, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _nameCustomer(model),

          Divider(
            color: Colors.grey,
          ),

          _productList(model),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: \u0024' + model.orderPrice.toStringAsFixed(2),
              style: textStyleOrderDetailsSectionTitle,
            ),
          ),
          SizedBox(height: 40),
          // _actions(context: context, model: model, provider: bloc),
          _actionButtons(bloc, context, scaffoldKey, model),
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

  Widget _actionButtons(OrderBlocProvider bloc, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: _buttonAccept(bloc, context, scaffoldKey, order),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 10,
          child: _buttonReject(bloc, context, scaffoldKey, order),
        )
      ],
    );
  }

  Widget _buttonAccept(OrderBlocProvider bloc, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) {
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
      onPressed: () =>
          _onPressedButtonAccept(bloc, context, scaffoldKey, order),
    );
  }

  void _onPressedButtonAccept(OrderBlocProvider bloc, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) async {
    Map<String, dynamic> response = await bloc.acceptOrder(order);
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

  Widget _buttonReject(OrderBlocProvider bloc, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) {
    return RaisedButton(
      child: Text('Rechazar',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: secondaryColor)),
      color: Colors.white,
      onPressed: () => _showAlert(context, bloc, scaffoldKey, order),
    );
  }

  void _showAlert(BuildContext context, OrderBlocProvider bloc,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) {
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
          content: 
          // Text('Something'),
          _dialogContent(order, bloc),
          actions: <Widget>[
            _buttonCancel(context),
            _buttonRejection(bloc, context, scaffoldKey, order)
          ],
        );
      },
    );
  }

  Widget _dialogContent(OrderModel order, OrderBlocProvider bloc) {
    return Wrap(
      children: <Widget>[
        Text(
          '¿En verdad quieres rechazar este pedido?',
          style: textStyleTitleListTile,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Escribe un mensaje para que ${order.customer.name} sepa por qué rechazaste su pedido',
            style: textStyleSubtitleListTile,
          ),
        ),
        _textFieldReasonRejection(bloc),
      ],
    );
  }

  Widget _textFieldReasonRejection(OrderBlocProvider bloc) {
    return StreamBuilder<String>(
      stream: bloc.rejectReasonStream,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Escribe el mensaje',
            contentPadding: EdgeInsets.all(16.0),
            errorText: snapshot.error,
          ),
          onChanged: bloc.changeRejectReason,
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

  Widget _buttonRejection(OrderBlocProvider bloc, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) {
    return StreamBuilder<String>(
        stream: bloc.rejectReasonStream,
        builder: (context, snapshot) {
          return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                    color: bloc.rejectReason == null || bloc.rejectReason.length == 0
                        ? Colors.grey
                        : primaryColor),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Aceptar',
                    style: TextStyle(
                        color:bloc.rejectReason == null ||  bloc.rejectReason.length == 0
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
              onPressed: bloc.rejectReason == null ||
                      bloc.rejectReason.length == 0
                  ? null
                  : () =>
                      _buttonRejectPressed(bloc, context, scaffoldKey, order));
        });
  }

  void _buttonRejectPressed(OrderBlocProvider bloc, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, OrderModel order) async {
    Map<String, dynamic> response =
        await bloc.rejectOrder(bloc.rejectReason, order);
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

  // Widget _actions(
  //     {OrderBlocProvider provider, OrderModel model, BuildContext context}) {
  //   return ButtonBar(
  //     alignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       RaisedButton(
  //           padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //           color: primaryColor,
  //           child: Text('Aceptar', style: textStyleBtnComprar),
  //           onPressed: () => _acceptOrder(model, provider, context)),
  //       RaisedButton(
  //         padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         onPressed: () => _showRejectDialog(
  //             bloc: provider, context: context, model: model),
  //         color: Colors.white,
  //         elevation: 0.0,
  //         child: Text(
  //           'Cancelar',
  //           style: signinLogin,
  //         ),
  //       )
  //     ],
  //   );
  // }

  // void _acceptOrder(
  //     OrderModel model, OrderBlocProvider bloc, BuildContext context) async {
  //   final Map<String, dynamic> response = await bloc.acceptOrder(model);
  //   if (response['ok']) {
  //     _showSnackBar(context, 'El pedido ha sido aceptado');
  //   } else {
  //     _showSnackBar(context, 'Ocurrió un error al aceptar el pedido');
  //   }
  // }

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
