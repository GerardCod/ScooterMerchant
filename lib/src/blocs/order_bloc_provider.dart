import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/blocs/validators.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class OrderBlocProvider with Validators {
  final _orderProvider = OrdersProvider();
  final _orderListController = BehaviorSubject<List<OrderModel>>();
  final _rejectReasonController = BehaviorSubject<String>();
  final _cancelReasonController = BehaviorSubject<String>();

  //Provider methods

  ///Retrieve a list of orders given the status and inProcess arguments.
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

  Future<Map<String, dynamic>> rejectOrder(
      OrderModel model, String message) async {
    return await _orderProvider.rejectOrder(model, message);
  }

  Future<Map<String, dynamic>> cancelOrder(
      OrderModel model, String reason) async {
    return await _orderProvider.cancelOrder(model, reason);
  }

  Future<Map<String, dynamic>> orderReady(OrderModel model) async {
    return await _orderProvider.orderReady(model);
  }

  //Order list stream

  Stream<List<OrderModel>> get orderListStream => _orderListController.stream;

  Function(List<OrderModel>) get changeOrderList =>
      _orderListController.sink.add;

  List<OrderModel> get orderList => _orderListController.value;

  //Reject reason stream

  Stream<String> get rejectReasonStream =>
      _rejectReasonController.stream.transform(validateRejectReason);

  Function(String) get changeRejectReason => _rejectReasonController.sink.add;

  String get rejectReason => _rejectReasonController.value;

  //Cancel reason stream

  Stream<String> get cancelReasonStream =>
      _cancelReasonController.stream.transform(validateRejectReason);

  Function(String) get changeCancelReason => _cancelReasonController.sink.add;

  String get cancelReason => _cancelReasonController.value;

  dispose() {
    _orderListController.close();
    _rejectReasonController.close();
    _cancelReasonController.close();
  }
}
