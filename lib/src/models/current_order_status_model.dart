
import 'package:scootermerchant/src/models/order_model.dart';

class CurrentOrderStatusModel {
  String orderStatus;
  DeliveryMan deliveryMan;

  CurrentOrderStatusModel({this.orderStatus, this.deliveryMan});

  factory CurrentOrderStatusModel.fromJson(Map<String, dynamic> json) =>
      CurrentOrderStatusModel(
        orderStatus: json['order_status'],
        deliveryMan: json["delivery_man"] != null
            ? DeliveryMan.fromJson(json['delivery_man'])
            : null,
      );
}