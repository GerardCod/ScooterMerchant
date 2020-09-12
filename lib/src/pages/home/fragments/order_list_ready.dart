import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/card_item.dart';
import 'package:shimmer/shimmer.dart';

class OrderListReady extends StatelessWidget {
  // const OrderHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    bloc.changeOrderList(null);
    bloc.getOrders('3,4,13,16', 'created');
    // bloc.getOrdersPickUp(status: 8);
    final Size size = MediaQuery.of(context).size;
    return _listStreamBuilder(bloc, size);
  }

  Widget _listStreamBuilder(OrderBlocProvider bloc, Size size) {
    return StreamBuilder(
        stream: bloc.orderListStream,
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
                  'No hay ningun pedido.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _listBuilder(snapshot, bloc);
        });
  }

  Widget _listBuilder(
      AsyncSnapshot<List<OrderModel>> snapshot, OrderBlocProvider bloc) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
                // OrderCard(
                //       model: snapshot.data[index],
                //       bloc: bloc,
                //       typeList: 'history',
                //     ),
                CardItem(snapshot.data[index]),
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
