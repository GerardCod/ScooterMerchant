import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/blocs/timezone_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/card_item.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends StatelessWidget {
  // const OrderHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final TimeZoneBlocProvider time = Provider.timeZoneBlocProviderOf(context);
    // bloc.changeOrderList(null);
    // if (bloc.orderListHistory == null) {
      bloc.getOrdersHistory(status: '', ordering: 'order_date');
    // }
    // bloc.getOrdersPickUp(status: 8);
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // bloc.changeOrderList(null);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: _customAppBar(context, bloc),
        body: _customBody(size, bloc, time),
      ),
    );
  }

  Widget _customAppBar(BuildContext context, OrderBlocProvider bloc) {
    return AppBar(
      title: Text(
        'Historial',
        style: txtStyleAppBar,
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      brightness: Brightness.light,
    );
  }

  Widget _customBody(
      Size size, OrderBlocProvider bloc, TimeZoneBlocProvider time) {
    return Container(
      width: size.width,
      height: size.height,
      child: _listStreamBuilder(bloc, size, time),
    );
  }

  Widget _listStreamBuilder(
      OrderBlocProvider bloc, Size size, TimeZoneBlocProvider time) {
    return StreamBuilder(
        stream: bloc.orderListHistoryStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (!snapshot.hasData) {
            return Shimmer.fromColors(
                child: _itemSkeleton(size),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]);
          }
          if (snapshot.data.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No hay ningun pedido en el historial.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return _listBuilder(snapshot, bloc, time);
        });
  }

  Widget _listBuilder(AsyncSnapshot<List<OrderModel>> snapshot,
      OrderBlocProvider bloc, TimeZoneBlocProvider time) {
    return ListView.builder(
      itemBuilder: (BuildContext contex, int index) {
        return CardItem(snapshot.data[index], time);
      },
      itemCount: snapshot.hasData ? snapshot.data.length : 0,
    );
  }

  Widget _itemSkeleton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: _listItemSkeleton()),
    );
  }

  List<Widget> _listItemSkeleton() {
    List listings = List<Widget>();
    for (int i = 0; i < 4; i++) {
      listings.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 70.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }
}
