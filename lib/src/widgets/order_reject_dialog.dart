import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/pages/notification_order_details_page_bloc.dart';
import 'package:scootermerchant/src/pages/home/home_page.dart';
import 'package:scootermerchant/utilities/constants.dart';

class OrderRejectDialog extends StatelessWidget {
  final NotificationOrderDetailsPageBloc bloc;
  // final OrderModel order;
  // final OrderBlocProvider bloc;
  const OrderRejectDialog({this.bloc});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text(
          'Confirmación de rechazo',
          style: textStyleOrderDetailsSectionTitle,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        elevation: 10.0,
        content: _dialogContent(bloc),
        actions: <Widget>[
          _buttonCancelRejection(context),
          _buttonRejection(bloc, context)
        ],
      ),
    );
  }

  Widget _dialogContent(NotificationOrderDetailsPageBloc bloc) {
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
          'Escribe un mensaje para que ${bloc.order.customer.name} sepa por qué rechazaste su pedido',
          style: textStyleSubtitleListTile,
        ),
        SizedBox(
          height: 8.0,
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
            labelText: 'Mensaje',
            contentPadding: EdgeInsets.all(16.0),
            errorText: snapshot.error,
          ),
          onChanged: bloc.changeReasonRejection,
        );
      },
    );
  }

  Widget _buttonCancelRejection(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'Cancelar',
        style: textStyleBtnComprar,
      ),
      shape: radiusButtons,
      color: primaryColor,
      padding: paddingButtons,
    );
  }

  Widget _buttonRejection(
      NotificationOrderDetailsPageBloc bloc, BuildContext context) {
    return FlatButton(
        child: Text(
          'Aceptar',
          style: signinLogin,
        ),
        color: Colors.white,
        padding: paddingButtons,
        onPressed: () => _onPreesedButtonReject(bloc, context));
  }

  void _onPreesedButtonReject(
      NotificationOrderDetailsPageBloc bloc, BuildContext context) {
    print('Reason Rejeciton============================================');
    print(bloc.reasonRejection);
    bloc.rejectOrder(bloc.reasonRejection);
    // if (bloc.responseAccept['ok']) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('homePage'));
    //  print("bloc.responseAccept['ok']========================");
    //  print(bloc.responseAccept['ok']);
    // _showSnackBar(context, bloc.responseAccept['message']);
    // } else {
    //  print("bloc.responseAccept['false']========================");
    //  print(bloc.responseAccept);
    //  print(bloc.responseAccept['ok']);
    // _showSnackBar(context, bloc.responseAccept['message']);
    // }
  }
}
