import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class CancelOrderDialog extends StatelessWidget {
  final OrderModel model;
  final OrderBlocProvider bloc;
  const CancelOrderDialog({Key key, this.model, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Confirmación de cancelación',
            style: textStyleOrderDetailsSectionTitle),
        shape: radiusButtons,
        content: _dialogContent(model),
        actions: <Widget>[
          _refuseCancelOrder(context),
          _cancelOrderStreamBuilder(bloc),
        ],
      ),
    );
  }

  Widget _dialogContent(OrderModel model) {
    return Column(
      children: <Widget>[
        Text('¿En verdad quieres cancelar este pedido?',
            style: textStyleOrderDetailsSectionTitle),
        SizedBox(
          height: 12.0,
        ),
        Text(
            'Escribe un mensaje para ${model.customer.name} con el motivo de la cancelación.',
            style: textStyleSubtitleListTile),
        SizedBox(
          height: 8.0,
        ),
        _reasonStreamBuilder(bloc),
      ],
    );
  }

  Widget _reasonStreamBuilder(OrderBlocProvider bloc) {
    return StreamBuilder(
        stream: bloc.cancelReasonStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return _cancelReasonTextField(bloc, snapshot);
        });
  }

  Widget _cancelReasonTextField(
      OrderBlocProvider bloc, AsyncSnapshot<String> snapshot) {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Mensaje',
          contentPadding: EdgeInsets.all(16.0),
          errorText: snapshot.error),
      onChanged: bloc.changeCancelReason,
    );
  }

  Widget _refuseCancelOrder(BuildContext context) {
    return RaisedButton(
        color: primaryColor,
        shape: radiusButtons,
        padding: paddingButtons,
        child: Text(
          'No',
          style: textStyleBtnComprar,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  Widget _cancelOrderStreamBuilder(OrderBlocProvider bloc) {
    return StreamBuilder(
      stream: bloc.cancelReasonStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return FlatButton(
            color: Colors.white,
            padding: paddingButtons,
            onPressed: snapshot.hasData
                ? () => this._cancelOrder(model, snapshot.data, context)
                : null,
            child: Text('Si', style: signinLogin));
      },
    );
  }

  void _cancelOrder(
      OrderModel model, String message, BuildContext context) async {
    final response = await bloc.cancelOrder(model, message);
    if (response['ok']) {
      Navigator.of(context)
          .pop({'ok': true, 'message': 'El pedido fue cancelado.'});
    } else {
      Navigator.of(context)
          .pop({'ok': false, 'message': 'Error al cancelar el pedido'});
    }
  }
}
