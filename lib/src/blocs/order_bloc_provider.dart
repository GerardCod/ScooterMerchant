import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/blocs/validators.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class OrderBlocProvider with Validators {
  final _orderProvider = OrdersProvider();

  // Controllers
  final _orderListController = BehaviorSubject<List<OrderModel>>();
  final _orderListAcceptedController = BehaviorSubject<List<OrderModel>>();
  final _orderListReadyController = BehaviorSubject<List<OrderModel>>();
  final _orderListHistoryController = BehaviorSubject<List<OrderModel>>();
  final _loaderListController = BehaviorSubject<bool>();
  final _rejectReasonController = BehaviorSubject<String>();
  final _cancelReasonController = BehaviorSubject<String>();
  final _loaderAcceptOrderController = BehaviorSubject<bool>();
  final _loaderRejectOrderController = BehaviorSubject<bool>();
  final _loaderFinishedOrderController = BehaviorSubject<bool>();
  final _loaderCancelOrderController = BehaviorSubject<bool>();

  // Streams
  Stream<List<OrderModel>> get orderListStream => _orderListController.stream;
  Stream<List<OrderModel>> get orderListAcceptedStream => _orderListAcceptedController.stream;
  Stream<List<OrderModel>> get orderListReadyStream => _orderListReadyController.stream;
  Stream<List<OrderModel>> get orderListHistoryStream => _orderListHistoryController.stream;
  Stream<bool> get loaderListStream => _loaderListController.stream;

  Stream<String> get rejectReasonStream => _rejectReasonController.stream;
  Stream<bool> get loaderAcceptOrderStream => _loaderAcceptOrderController.stream;
  Stream<bool> get loaderFinishedOrderStream => _loaderFinishedOrderController.stream;
  Stream<bool> get loaderCancelOrderStream => _loaderCancelOrderController.stream;
  Stream<bool> get loaderRejectOrderStream => _loaderRejectOrderController.stream;
  Stream<String> get cancelReasonStream => _cancelReasonController.stream;

  // Insert
  Function(List<OrderModel>) get changeOrderList => _orderListController.sink.add;
  Function(List<OrderModel>) get changeOrderListAccepted => _orderListAcceptedController.sink.add;
  Function(List<OrderModel>) get changeOrderListReady => _orderListReadyController.sink.add;
  Function(List<OrderModel>) get changeOrderListHistory => _orderListHistoryController.sink.add;
  Function(bool) get changeLoaderList => _loaderListController.sink.add;

  Function(bool) get changeLoaderAcceptOrder => _loaderAcceptOrderController.sink.add;
  Function(bool) get changeLoaderRejectOrder => _loaderRejectOrderController.sink.add;
  Function(bool) get changeLoaderFinishedOrder => _loaderFinishedOrderController.sink.add;
  Function(bool) get changeLoaderCancelOrder => _loaderCancelOrderController.sink.add;
  Function(String) get changeRejectReason => _rejectReasonController.sink.add;
  Function(String) get changeCancelReason => _cancelReasonController.sink.add;

  // Ultimos valores
  List<OrderModel> get orderList => _orderListController.value;
  List<OrderModel> get orderListAccepted => _orderListAcceptedController.value;
  List<OrderModel> get orderListReady => _orderListReadyController.value;
  List<OrderModel> get orderListHistory => _orderListHistoryController.value;
  bool get loaderList => _loaderListController.value;

  bool get loaderAcceptOrder => _loaderAcceptOrderController.value;
  bool get loaderRejectOrder => _loaderRejectOrderController.value;
  bool get loaderFinishedOrder => _loaderFinishedOrderController.value;
  bool get loaderCancelOrder => _loaderCancelOrderController.value;
  String get rejectReason => _rejectReasonController.value;
  String get cancelReason => _cancelReasonController.value;

  Future<List<OrderModel>> getOrders({String status, String ordering}) async {
    changeLoaderList(true);
    final orders = await _orderProvider.getOrders(status: status, ordering: ordering);
    changeOrderList(orders);
    changeLoaderList(false);
    return orders;
  }
  Future<List<OrderModel>> getOrdersReady({String status, String ordering}) async {
    changeLoaderList(true);
    final orders = await _orderProvider.getOrders(status: status, ordering: ordering);
    changeOrderListReady(orders);
    changeLoaderList(false);
    return orders;
  }
  Future<List<OrderModel>> getOrdersAccepted({String status, String ordering}) async {
    changeLoaderList(true);
    final orders = await _orderProvider.getOrders(status: status, ordering: ordering);
    changeOrderListAccepted(orders);
    changeLoaderList(false);
    return orders;
  }
  Future<List<OrderModel>> getOrdersHistory({String status, String ordering}) async {
    changeLoaderList(true);
    final orders = await _orderProvider.getOrders(status: status, ordering: ordering);
    changeOrderListHistory(orders);
    changeLoaderList(false);
    return orders;
  }

  Future<Map<String, dynamic>> acceptOrder(OrderModel model) async {
    changeLoaderAcceptOrder(true);
    Map<String, dynamic> response = await _orderProvider.acceptOrder(model);
    // changeResponseAccept(response);
    changeLoaderAcceptOrder(false);
    return response;
  }

  Future<Map<String, dynamic>> rejectOrder(
      String messageReject, OrderModel model) async {
    changeLoaderRejectOrder(true);
    Map<String, dynamic> response =
        await _orderProvider.rejectOrder(model, messageReject);
    // changeResponseReject(response);
    changeLoaderRejectOrder(false);
    return response;
  }

  Future<Map<String, dynamic>> cancelOrder(
      OrderModel model, String reason) async {
    changeLoaderCancelOrder(true);
    Map<String, dynamic> response =
        await _orderProvider.cancelOrder(model, reason);
    changeLoaderCancelOrder(false);
    return response;
  }

  Future<Map<String, dynamic>> orderFinshed(OrderModel model) async {
    changeLoaderFinishedOrder(true);
    Map<String, dynamic> response = await _orderProvider.orderReady(model);
    changeLoaderFinishedOrder(false);
    print(response);
    return response; 
  }

  Future<Map<String, dynamic>> getOrder(String orderId) async {
    return await _orderProvider.getOrder(orderId);
  }

  dispose() {
    _orderListController?.close();
    _orderListAcceptedController?.close();
    _orderListReadyController?.close();
    _orderListHistoryController?.close();
    _loaderListController?.close();
    _rejectReasonController?.close();
    _cancelReasonController?.close();
    _loaderAcceptOrderController?.close();
    _loaderRejectOrderController?.close();
    _loaderFinishedOrderController?.close();
    _loaderCancelOrderController?.close();
  }
}
