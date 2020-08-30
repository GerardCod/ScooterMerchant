import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class NotificationOrderDetailsPageBloc {
  OrdersProvider ordersProvider = new OrdersProvider();
  // Controllers
  final _detailsListController = BehaviorSubject<List<Details>>();
  final _orderController = BehaviorSubject<OrderModel>();
  final _responseAcceptController = BehaviorSubject<Map<String, dynamic>>();
  final _responseRejectController = BehaviorSubject<Map<String, dynamic>>();
  final _loaderAcceptOrderController = BehaviorSubject<bool>();
  final _loaderRejectOrderController = BehaviorSubject<bool>();
  final _reasonRejectionController = BehaviorSubject<String>();

  // Streams
  Stream<List<Details>> get detailsListStream => _detailsListController.stream;
  Stream<OrderModel> get orderStream => _orderController.stream;
  Stream<Map<String, dynamic>> get responseAcceptStream => _responseAcceptController.stream;
  Stream<Map<String, dynamic>> get responseRejectStream => _responseRejectController.stream;
  Stream<bool> get loaderAcceptOrderStream => _loaderAcceptOrderController.stream;
  Stream<bool> get loaderRejectOrderStream => _loaderRejectOrderController.stream;
  Stream<String> get reasonRejectionStream => _reasonRejectionController.stream;

  // Insert Values
  Function(List<Details>) get changeDetailsList => _detailsListController.sink.add;
  Function(OrderModel) get changeOrder => _orderController.sink.add;
  Function(Map<String, dynamic>) get changeResponseAccept => _responseAcceptController.sink.add;
  Function(Map<String, dynamic>) get changeResponseReject => _responseRejectController.sink.add;
  Function(bool) get changeLoaderAcceptOrder => _loaderAcceptOrderController.sink.add;
  Function(bool) get changeLoaderRejectOrder => _loaderRejectOrderController.sink.add;
  Function(String) get changeReasonRejection => _reasonRejectionController.sink.add;

  // Ultimos valores
  List<Details> get detailsList => _detailsListController.value;
  OrderModel get order => _orderController.value;
  Map<String, dynamic> get responseAccept => _responseAcceptController.value;
  Map<String, dynamic> get responseReject => _responseRejectController.value;
  bool get loaderAcceptOrder => _loaderAcceptOrderController.value;
  bool get loaderRejectOrder => _loaderRejectOrderController.value;
  String get reasonRejection => _reasonRejectionController.value;

  // Methods
  Future<OrderModel> getOrder({String orderId, int indexDetails, int indexMenuOptions}) async {
    // changeisResponseOk(true);
    Map<String, dynamic> response = await ordersProvider.getOrder(orderId);
    OrderModel orderModel = response['order'];
    changeOrder(orderModel);
    changeDetailsList(orderModel.details);
    // changeLoaderPage(false);
  }

  Future<Map<String, dynamic>> acceptOrder() async{
    // print('OrderModel Id ==================================');
    // print(order.id);
    changeLoaderAcceptOrder(true);
    Map<String, dynamic> response = await ordersProvider.acceptOrder(order);
    // changeResponseAccept(response);
    changeLoaderAcceptOrder(false);
    return response;
  }

  Future<Map<String, dynamic>> rejectOrder(String messageReject) async{
    // print('OrderModel Id ==================================');
    // print(order.id);
    changeLoaderRejectOrder(true);
    Map<String, dynamic> response = await ordersProvider.rejectOrder(order, messageReject);
    // changeResponseReject(response);
    changeLoaderRejectOrder(false);
    return response;
  }

  void drainStream() {
    _reasonRejectionController.value = null;
  }

  dispose() {
    _detailsListController?.close();
    _orderController?.close();
    _responseAcceptController?.close();
    _responseRejectController?.close();
    _loaderAcceptOrderController?.close();
    _loaderRejectOrderController?.close();
    _reasonRejectionController?.close();
  }
}
