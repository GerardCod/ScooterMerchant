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
  final _loaderFinishedOrderController = BehaviorSubject<bool>();
  final _loaderCancelOrderController = BehaviorSubject<bool>();
  

  // Streams
  Stream<bool> get loaderAcceptOrderStream => _loaderAcceptOrderController.stream;
  Stream<bool> get loaderFinishedOrderStream => _loaderAcceptOrderController.stream;
  Stream<bool> get loaderCancelOrderStream => _loaderAcceptOrderController.stream;
  Stream<bool> get loaderRejectOrderStream => _loaderRejectOrderController.stream;
  Stream<String> get rejectReasonStream => _rejectReasonController.stream;
  Stream<String> get cancelReasonStream => _cancelReasonController.stream;

  // Insert
  Function(bool) get changeLoaderAcceptOrder => _loaderAcceptOrderController.sink.add;
  Function(bool) get changeLoaderRejectOrder => _loaderRejectOrderController.sink.add;
  Function(bool) get changeLoaderFinishedOrder => _loaderRejectOrderController.sink.add;
  Function(bool) get changeLoaderCancelOrder => _loaderRejectOrderController.sink.add;
  Function(String) get changeRejectReason => _rejectReasonController.sink.add;
  Function(String) get changeCancelReason => _cancelReasonController.sink.add;

  // Ultimos valores
  bool get loaderAcceptOrder => _loaderAcceptOrderController.value;
  bool get loaderRejectOrder => _loaderRejectOrderController.value;
  bool get loaderFinishedOrder => _loaderRejectOrderController.value;
  bool get loaderCancelOrder => _loaderRejectOrderController.value;
  String get rejectReason => _rejectReasonController.value;
  String get cancelReason => _cancelReasonController.value;


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

  Future<Map<String, dynamic>> cancelOrder(OrderModel model, String reason) async {
    changeLoaderCancelOrder(true);
    Map<String, dynamic> response = await _orderProvider.cancelOrder(model, reason);
    changeLoaderCancelOrder(false);
    return response;
  }

  Future<Map<String, dynamic>> orderFinshed(OrderModel model) async {
    changeLoaderFinishedOrder(true);
    Map<String, dynamic> response =  await _orderProvider.orderReady(model);
    changeLoaderFinishedOrder(false);
    return response;
  }
  
  Future<Map<String, dynamic>> getOrder(String orderId) async {
    return await _orderProvider.getOrder(orderId);
  }

  //Order list stream

  Stream<List<OrderModel>> get orderListStream => _orderListController.stream;

  Function(List<OrderModel>) get changeOrderList =>
      _orderListController.sink.add;

  List<OrderModel> get orderList => _orderListController.value;

  dispose() {
    _orderListController?.close();
    _rejectReasonController?.close();
    _cancelReasonController?.close();
    _loaderAcceptOrderController?.close();
    _loaderRejectOrderController?.close();
    _loaderFinishedOrderController?.close();
    _loaderCancelOrderController?.close();
  }
}
