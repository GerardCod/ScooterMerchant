import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderRejectDialog extends StatelessWidget {
  final OrderModel order;
  final OrderBlocProvider bloc;
  const OrderRejectDialog({Key key, this.order, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Confirmación de rechazo',
          style: textStyleOrderDetailsSectionTitle,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        elevation: 10.0,
        content: _dialogContent(),
        actions: <Widget>[
          _cancelRejectButton(context),
          _streamBuilderRejectButton(bloc, order)
        ],
      ),
    );
  }

  Widget _dialogContent() {
    return Column(
      children: <Widget>[
        Text(
          '¿En verdad quieres rechazar este pedido?',
          style: textStyleTitleListTile,
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(
          'Escribe un mensaje para que ${this.order.customer.name} sepa por qué rechazaste su pedido',
          style: textStyleSubtitleListTile,
        ),
        SizedBox(
          height: 8.0,
        ),
        _reasonStreamBuilder(bloc),
      ],
    );
  }

  Widget _reasonStreamBuilder(OrderBlocProvider bloc) {
    return StreamBuilder(
      stream: bloc.rejectReasonStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return _rejectReasonTextField(bloc, snapshot);
      },
    );
  }

  Widget _rejectReasonTextField(
      OrderBlocProvider bloc, AsyncSnapshot<String> snapshot) {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Mensaje',
        contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        errorText: snapshot.error,
      ),
      onChanged: bloc.changeRejectReason,
    );
  }

  Widget _cancelRejectButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'No',
        style: textStyleBtnComprar,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      color: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8.0),
    );
  }

  Widget _streamBuilderRejectButton(OrderBlocProvider bloc, OrderModel model) {
    return StreamBuilder(
      stream: bloc.rejectReasonStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return FlatButton(
          child: Text(
            'Si',
            style: signinLogin,
          ),
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8.0),
          onPressed: snapshot.hasData
              ? () => this._rejectOrder(model, snapshot.data, context: context)
              : null,
        );
      },
    );
  }

  void _rejectOrder(OrderModel model, String message,
      {BuildContext context}) async {
    final response = await bloc.rejectOrder(model, message);
    print(response);
    if (response['ok']) {
      Navigator.of(context).pop();
      _showSnackBar('Pedido rechazado', context);
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
