import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scootermerchant/src/blocs/pages/delivery_pick_up_page_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/current_order_status_model.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class DeliveryPickUp extends StatefulWidget {
  final OrderModel orderModel;

  DeliveryPickUp(this.orderModel);

  @override
  _DeliveryPickUpState createState() => _DeliveryPickUpState(this.orderModel);
}

class _DeliveryPickUpState extends State<DeliveryPickUp> {
  OrderModel orderModel;
  _DeliveryPickUpState(this.orderModel);

  final DEFAULT_LOCATION = LatLng(18.462734, -97.395616);

  GoogleMapController controller;

  Set<Marker> _markers = {};

  BitmapDescriptor _iconMerchant;

  BitmapDescriptor _iconCustomer;

  BitmapDescriptor _iconDelivery;

  DeliveryPickUpPageBloc pickUpPageBloc; 

  Timer timer;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    // pickUpPageBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.timer = Timer.periodic(
        Duration(seconds: 40), (Timer timer) => getCurrentOrderStatus());
  }

  @override
  Widget build(BuildContext context) {
    pickUpPageBloc = Provider.deliveryPickUpPageBloc(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _customAppBar(),
      body: _customBody(size),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        'Ubicación del repartidor',
        style: txtStyleAppBar,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  Widget _customBody(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      child: _showMap(),
    );
  }

  Widget _showMap() {
    return StreamBuilder<Set<Marker>>(
        stream: pickUpPageBloc.listMarkersStream,
        builder: (context, snapshot) {
          // print('snapshot.data===============================');
          // print(snapshot.hasData);
          // if (snapshot.hasData) {
          return GoogleMap(
            compassEnabled: false,
            buildingsEnabled: false,
            trafficEnabled: false,
            mapType: MapType.normal,
            markers: snapshot.hasData ? snapshot.data : null,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: DEFAULT_LOCATION,
              // zoom: 13,
            ),
            onMapCreated: (GoogleMapController controller) {
              this.controller = controller;
              // print('Entra en onMapCreated');
              _createMarkers();
            },
          );
        });
  }

  void _createMarkers() async {
    await _buildIconImage();

    // Marker delivery
    List<double> coordinatesDelivery =
        orderModel.deliveryMan.location.coordinates;
    LatLng latLngDelivery =
        LatLng(coordinatesDelivery[1], coordinatesDelivery[0]);
    Marker markerDelivery = Marker(
      markerId: MarkerId('delivery'),
      position: latLngDelivery,
      icon: _iconDelivery,
    );

    // Marker Merchant
    List<double> coordinatesMerchant = orderModel.merchantLocation.coordinates;
    LatLng latLngMerchant =
        LatLng(coordinatesMerchant[1], coordinatesMerchant[0]);
    Marker markerMerchant = new Marker(
      markerId: new MarkerId('merchant'),
      position: latLngMerchant,
      icon: _iconMerchant,
    );

    // Marker Customer
    List<double> coordinatesCustomer = orderModel.toAddress.point.coordinates;
    LatLng latLngCustomer =
        LatLng(coordinatesCustomer[1], coordinatesCustomer[0]);
    Marker markerCustomer = Marker(
      markerId: MarkerId('customer'),
      position: latLngCustomer,
      icon: _iconCustomer,
    );

    // Add to list of markers
    _markers.add(markerMerchant);
    _markers.add(markerCustomer);
    _markers.add(markerDelivery);
    pickUpPageBloc.changeListMarkers(_markers);

// Pruebas
    LatLngBounds bound;
    if (latLngMerchant.latitude > latLngCustomer.latitude &&
        latLngMerchant.longitude > latLngCustomer.longitude) {
      bound =
          LatLngBounds(southwest: latLngCustomer, northeast: latLngMerchant);
    } else if (latLngMerchant.longitude > latLngCustomer.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(latLngMerchant.latitude, latLngCustomer.longitude),
          northeast: LatLng(latLngCustomer.latitude, latLngMerchant.longitude));
    } else if (latLngMerchant.latitude > latLngCustomer.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(latLngCustomer.latitude, latLngMerchant.longitude),
          northeast: LatLng(latLngMerchant.latitude, latLngCustomer.longitude));
    } else {
      bound =
          LatLngBounds(southwest: latLngMerchant, northeast: latLngCustomer);
    }

    Future.delayed(new Duration(milliseconds: 100), () {
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);

      this.controller.animateCamera(u2).then((void v) {
        check(u2, this.controller);
      });
    });
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    controller.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      check(u, c);
    }
  }

  void _buildIconImage() async {
    var onValue =
        await getBytesFromAsset('assets/images/maps/icon_merchant.png', 128);
    _iconMerchant = BitmapDescriptor.fromBytes(onValue);

    var onValue1 =
        await getBytesFromAsset('assets/images/maps/icon_customer.png', 128);
    _iconCustomer = BitmapDescriptor.fromBytes(onValue1);

    var onValue2 =
        await getBytesFromAsset('assets/images/maps/icon_delivery.png', 128);
    _iconDelivery = BitmapDescriptor.fromBytes(onValue2);
  }

  void getCurrentOrderStatus() async {
    CurrentOrderStatusModel orderStatusModel = await pickUpPageBloc
        .getCurrentOrderStatus(orderId: orderModel.id.toString());
    // print('Order Status===============================================');
    // print(orderStatusModel.orderStatus);
    // List<double> coordinatesCustomer = orderModel.toAddress.point.coordinates;
    // LatLng latLngCustomer = LatLng(18.4630928, -97.3958046);

    if (orderStatusModel.deliveryMan != null) {
      List<double> currentLocationDelivery =
          orderStatusModel.deliveryMan.location.coordinates;
      LatLng latLngCurrentLocationDelivery =
          LatLng(currentLocationDelivery[1], currentLocationDelivery[0]);

      Marker markerCurrentLocationDelivery = Marker(
        markerId: MarkerId('delivery'),
        position: latLngCurrentLocationDelivery,
        icon: _iconDelivery,
      );

      // LatLngBounds boundCurrent;
      // if (latLngCurrentLocationDelivery.latitude > latLngCustomer.latitude &&
      //     latLngCurrentLocationDelivery.longitude > latLngCustomer.longitude) {
      //   boundCurrent = LatLngBounds(
      //       southwest: latLngCustomer,
      //       northeast: latLngCurrentLocationDelivery);
      // } else if (latLngCurrentLocationDelivery.longitude >
      //     latLngCustomer.longitude) {
      //   boundCurrent = LatLngBounds(
      //       southwest: LatLng(latLngCurrentLocationDelivery.latitude,
      //           latLngCustomer.longitude),
      //       northeast: LatLng(latLngCustomer.latitude,
      //           latLngCurrentLocationDelivery.longitude));
      // } else if (latLngCurrentLocationDelivery.latitude >
      //     latLngCustomer.latitude) {
      //   boundCurrent = LatLngBounds(
      //       southwest: LatLng(latLngCustomer.latitude,
      //           latLngCurrentLocationDelivery.longitude),
      //       northeast: LatLng(latLngCurrentLocationDelivery.latitude,
      //           latLngCustomer.longitude));
      // } else {
      //   boundCurrent = LatLngBounds(
      //       southwest: latLngCurrentLocationDelivery,
      //       northeast: latLngCustomer);
      // }

      if (_markers.length > 0) {
        _markers.add(markerCurrentLocationDelivery);
        pickUpPageBloc.changeListMarkers(_markers);
      }
      // Future.delayed(new Duration(milliseconds: 100), () {
      //   CameraUpdate u2 = CameraUpdate.newLatLngBounds(boundCurrent, 50);

      //   this.controller.animateCamera(u2).then((void v) {
      //     check(u2, this.controller);
      //   });
      // });
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
