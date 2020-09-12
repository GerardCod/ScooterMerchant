import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/card_item.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPage extends StatelessWidget {
  // const OrderHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    bloc.changeOrderList(null);
    bloc.getOrders('6,7,8,17','created');
    // bloc.getOrdersPickUp(status: 8);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _customAppBar(),
      body: _customBody(size, bloc),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      title: Text(
        'Historial',
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: primaryColor,
    );
  }

  Widget _customBody(Size size, OrderBlocProvider bloc) {
    return Container(
      width: size.width,
      height: size.height,
      child: _listStreamBuilder(bloc, size),
    );
  }

  Widget _listStreamBuilder(OrderBlocProvider bloc, Size size) {
    return StreamBuilder(
        stream: bloc.orderListStream,
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
                'No hay ningun pedido.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return _listBuilder(snapshot, bloc);
        });
  }

  Widget _listBuilder(
    AsyncSnapshot<List<OrderModel>> snapshot,
    OrderBlocProvider bloc,
  ) {
    return ListView.builder(
      itemBuilder: (BuildContext contex, int index) {
        return CardItem(snapshot.data[index]);
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
    for (int i = 0; i < 10; i++) {
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
