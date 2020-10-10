import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scootermerchant/src/models/current_order_status_model.dart';
import 'package:scootermerchant/src/providers/orders_provider.dart';

class DeliveryPickUpPageBloc {
  OrdersProvider ordersProvider = new OrdersProvider();
  // Controllers
  final _listMarkersController = BehaviorSubject<Set<Marker>>();
  // final _markerController = BehaviorSubject<Marker>();

  // Streams
  Stream<Set<Marker>> get listMarkersStream => _listMarkersController.stream;
  // Stream<Marker> get markerStream => _markerController.stream;

  // Insert Values
  Function(Set<Marker>) get changeListMarkers => _listMarkersController.sink.add;
  // Function(Marker) get changeMarker => _markerController.sink.add;

  // Ultimos valores
  Set<Marker> get listMarkers => _listMarkersController.value;

  
  Future<CurrentOrderStatusModel> getCurrentOrderStatus({String orderId}) async {
    CurrentOrderStatusModel orderStatusModel = await ordersProvider.getCurrentOrderStatus(orderId);
    return orderStatusModel;
  }

  dispose() {
    _listMarkersController?.close();
  }
}
