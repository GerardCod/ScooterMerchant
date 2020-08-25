import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class OrderBlocProvider {
  final _orderProvider = OrdersProvider();
  final _orderListController = BehaviorSubject<List<OrderModel>>();

  Future<List<OrderModel>> getOrders() async {
    final orders = await _orderProvider.getOrders();
    changeOrderList(orders);
    return orders;
  }

  Stream<List<OrderModel>> get orderListStream => _orderListController.stream;

  Function(List<OrderModel>) get changeOrderList =>
      _orderListController.sink.add;

  List<OrderModel> get orderList => _orderListController.value;

  dispose() {
    _orderListController.close();
  }
}
