import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/blocs/timezone_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/card_item.dart';
import 'package:shimmer/shimmer.dart';

class OrderListReady extends StatelessWidget {
  // const OrderListReady({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final TimeZoneBlocProvider time = Provider.timeZoneBlocProviderOf(context);
    final Size size = MediaQuery.of(context).size;
    // bloc.changeOrderList(null);
    // if (bloc.orderListReady == null) {
      bloc.getOrdersReady(status: '3,4,13,16', ordering: 'order_date');
    // }
    // bloc.getOrdersPickUp(status: 8);x
    return _listStreamBuilder(bloc, size, time);
  }

  Widget _listStreamBuilder(
      OrderBlocProvider bloc, Size size, TimeZoneBlocProvider time) {
    return StreamBuilder(
        stream: bloc.orderListReadyStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Shimmer.fromColors(
                  child: _itemSkeleton(size),
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100]),
            );
          }
          if (snapshot.data.length == 0) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No hay ningún pedido listo.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _listBuilder(snapshot, bloc, time);
        });
  }

  Widget _listBuilder(AsyncSnapshot<List<OrderModel>> snapshot,
      OrderBlocProvider bloc, TimeZoneBlocProvider time) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                CardItem(snapshot.data[index], time),
            childCount: snapshot.hasData ? snapshot.data.length : 0));
  }

  Widget _itemSkeleton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
