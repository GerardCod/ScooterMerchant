import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/order_card.dart';
import 'package:shimmer/shimmer.dart';

class OrderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderListBloc = Provider.orderBlocProviderOf(context);
    final size = MediaQuery.of(context).size;
    orderListBloc.changeOrderList(null);
    orderListBloc.getOrders();
    return _listStreamBuilder(orderListBloc, size);
  }

  Widget _listStreamBuilder(OrderBlocProvider orderBloc, Size size) {
    return StreamBuilder<List<OrderModel>>(
      stream: orderBloc.orderListStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: _itemSkeleton(size),
            ),
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
        return _listBuilder(context, snapshot, bloc: orderBloc);
      },
    );
  }

  Widget _listBuilder(
      BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot,
      {OrderBlocProvider bloc}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _listItem(snapshot.data[index], bloc),
        childCount: snapshot.hasData ? snapshot.data.length : 0,
      ),
    );
  }

  Widget _listItem(OrderModel model, OrderBlocProvider bloc) {
    return OrderCard(
      model: model,
      bloc: bloc,
      typeList: 'incoming',
    );
  }

  Widget _itemSkeleton(Size size) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _listItemSkeleton(size),
      ),
    );
  }

  List<Widget> _listItemSkeleton(Size size) {
    List listings = List<Widget>();
    for (int i = 0; i < 5; i++) {
      listings.add(
        Container(
          margin: EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 150.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }
}
