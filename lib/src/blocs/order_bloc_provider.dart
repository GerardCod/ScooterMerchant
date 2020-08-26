import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class OrderBlocProvider {
  final _orderProvider = OrdersProvider();
  final _orderListController = BehaviorSubject<List<OrderModel>>();

  Future<List<OrderModel>> getOrders(
      {int status = 14, bool inProcess = false}) async {
    final orders =
        await _orderProvider.getOrders(status: status, inProcess: inProcess);
    changeOrderList(orders);
    return orders;
  }

  Future<Map<String, dynamic>> acceptOrder(OrderModel model) async {
    return await _orderProvider.acceptOrder(model);
  }

  Stream<List<OrderModel>> get orderListStream => _orderListController.stream;

  Function(List<OrderModel>) get changeOrderList =>
      _orderListController.sink.add;

  List<OrderModel> get orderList => _orderListController.value;

  dispose() {
    _orderListController.close();
  }
}
