import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/blocs/validators.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class OrderBlocProvider with Validators {
  final _orderProvider = OrdersProvider();

  // Controllers
  final _orderListController = BehaviorSubject<List<OrderModel>>();
  final _rejectReasonController = BehaviorSubject<String>();
  final _cancelReasonController = BehaviorSubject<String>();
  final _loaderAcceptOrderController = BehaviorSubject<bool>();
  final _loaderRejectOrderController = BehaviorSubject<bool>();
  

  // Streams
  Stream<bool> get loaderAcceptOrderStream => _loaderAcceptOrderController.stream;
  Stream<bool> get loaderRejectOrderStream => _loaderRejectOrderController.stream;
  Stream<String> get rejectReasonStream => _rejectReasonController.stream;


  // Insert
  Function(bool) get changeLoaderAcceptOrder => _loaderAcceptOrderController.sink.add;
  Function(bool) get changeLoaderRejectOrder => _loaderRejectOrderController.sink.add;
  Function(String) get changeRejectReason => _rejectReasonController.sink.add;

  // Ultimos valores
  bool get loaderAcceptOrder => _loaderAcceptOrderController.value;
  bool get loaderRejectOrder => _loaderRejectOrderController.value;
  String get rejectReason => _rejectReasonController.value;


  //Provider methods

  ///Retrieve a list of orders given the status and inProcess arguments.
  Future<List<OrderModel>> getOrders(
      {int status = 14, bool inProcess = false, bool allOrders = false}) async {
    final orders = await _orderProvider.getOrders(
        status: status, inProcess: inProcess, allOrders: allOrders);
    changeOrderList(orders);
    return orders;
  }

  Future<Map<String, dynamic>> acceptOrder(OrderModel model) async{
    // print('OrderModel Id ==================================');
    // print(order.id);
    changeLoaderAcceptOrder(true);
    Map<String, dynamic> response = await _orderProvider.acceptOrder(model);
    // changeResponseAccept(response);
    changeLoaderAcceptOrder(false);
    return response;
  }

  Future<Map<String, dynamic>> rejectOrder(String messageReject, OrderModel model) async{
    // print('OrderModel Id ==================================');
    // print(order.id);
    changeLoaderRejectOrder(true);
    Map<String, dynamic> response = await _orderProvider.rejectOrder(model, messageReject);
    // changeResponseReject(response);
    changeLoaderRejectOrder(false);
    return response;
  }

  // Future<Map<String, dynamic>> acceptOrder(OrderModel model) async {

  //    _orderProvider.acceptOrder(model);
  // }

  // Future<Map<String, dynamic>> rejectOrder(
  //     OrderModel model, String message) async {
  //   return await _orderProvider.rejectOrder(model, message);
  // }

  Future<Map<String, dynamic>> cancelOrder(
      OrderModel model, String reason) async {
    return await _orderProvider.cancelOrder(model, reason);
  }

  Future<Map<String, dynamic>> orderReady(OrderModel model) async {
    return await _orderProvider.orderReady(model);
  }
  Future<Map<String, dynamic>> getOrder(String orderId) async {
    return await _orderProvider.getOrder(orderId);
  }

  //Order list stream

  Stream<List<OrderModel>> get orderListStream => _orderListController.stream;

  Function(List<OrderModel>) get changeOrderList =>
      _orderListController.sink.add;

  List<OrderModel> get orderList => _orderListController.value;

  //Cancel reason stream

  Stream<String> get cancelReasonStream =>
      _cancelReasonController.stream.transform(validateRejectReason);

  Function(String) get changeCancelReason => _cancelReasonController.sink.add;

  String get cancelReason => _cancelReasonController.value;

  dispose() {
    _orderListController?.close();
    _rejectReasonController?.close();
    _cancelReasonController?.close();
    _loaderAcceptOrderController?.close();
    _loaderRejectOrderController?.close();
  }
}
