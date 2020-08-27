import 'package:rxdart/rxdart.dart';

import '../../models/order_model.dart';
import '../../providers/orders_provider.dart';

class NotificationOrderDetailsPageBloc {
  OrdersProvider ordersProvider = new OrdersProvider();
  // Controllers
  final _detailsListController = BehaviorSubject<List<Details>>();
  final _orderController = BehaviorSubject<OrderModel>();
  final _loaderPageController = BehaviorSubject<bool>();

  // Streams
  Stream<List<Details>> get detailsListStream => _detailsListController.stream;
  Stream<OrderModel> get orderStream => _orderController.stream;
  Stream<bool> get loaderPageStream => _loaderPageController.stream;

  // Insert Values
  Function(List<Details>) get changeDetailsList =>
      _detailsListController.sink.add;
  Function(OrderModel) get changeOrder => _orderController.sink.add;
  Function(bool) get changeloaderPage => _loaderPageController.sink.add;

  // Ultimos valores
  List<Details> get detailsList => _detailsListController.value;
  OrderModel get order => _orderController.value;
  bool get loaderPage => _loaderPageController.value;

  // Methods
  Future<OrderModel> getOrder({String orderId}) async {
    changeloaderPage(true);
    Map<String, dynamic> response = await ordersProvider.getOrder(orderId);
    OrderModel orderModel = response['order'];
    changeOrder(orderModel);
    changeDetailsList(orderModel.details);
    changeloaderPage(false);
  }

  dispose() {
    _detailsListController?.close();
    _orderController?.close();
    _loaderPageController?.close();
  }
}
