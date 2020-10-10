import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scootermerchant/src/blocs/timezone_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/pages/order_details/order_details_page.dart';
import 'package:scootermerchant/src/pages/order_details/pick_up/order_details_page_pick_up.dart';
import 'package:scootermerchant/utilities/constants.dart';

class CardItem extends StatelessWidget {
  // const CardItem({Key key}) : super(key: key);
  final OrderModel orderModel;
  final TimeZoneBlocProvider bloc;

  CardItem(this.orderModel, this.bloc);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es_MX');
    return _item(orderModel, context);
  }

  Widget _item(OrderModel orderModel, BuildContext context) {
    String name = orderModel.customer.name;
    String qrCode = orderModel.qrCode;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Card(
        elevation: 3,
        child: ListTile(
          contentPadding: EdgeInsets.all(8),
          onTap: () {
            if (orderModel.deliveryMan != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPagePickUp(orderModel),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(orderModel),
                ),
              );
            }
          },
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(qrCode),
              Text(_dateConvert(orderModel.orderDate))
            ],
          ),
          trailing: _returnTrailingItem(orderModel),
        ),
      ),
    );
  }

  Widget _returnTrailingItem(OrderModel orderModel) {
    if (orderModel.orderStatus.id == 14 || orderModel.orderStatus.id == 15) {
      return Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
      );
    }
    if (orderModel.deliveryMan != null) {
      if (orderModel.orderStatus.id == 6) {
        return _showOrderStatus();
      }
      return _imageDelivery(orderModel.deliveryMan.picture);
    } else {
      return _showOrderStatus();
    }
  }

  Widget _showOrderStatus() {
    return Container(
      width: 100,
      height: 40,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: _showColorStatus(),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          orderModel.orderStatus.name,
          style: TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
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

  Widget _imageDelivery(String picture) {
    if (picture != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          color: Colors.grey,
          width: 40,
          height: 40,
          child: FadeInImage(
              placeholder: AssetImage('assets/images/no_image.png'),
              image: NetworkImage('$picture')),
        ),
      );
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: primaryColor,
    );
  }

  // String _dateConvert(DateTime date) {
  //   String dateConverted = DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
  //   return dateConverted;
  // }

  _dateConvert(String date) {
    DateTime dateParsed = bloc.convertLocalToMexico(date);
    return DateFormat.yMEd('es_MX').add_jms().format(dateParsed);
  }
}
