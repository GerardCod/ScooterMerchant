import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/order_card.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class OrderListAccepted extends StatelessWidget {
  const OrderListAccepted({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final size = MediaQuery.of(context).size;
    bloc.changeOrderList(null);
    bloc.getOrders(status: status['in_process'], inProcess: true);
    return _listStreamBuilder(bloc, size);
  }

  Widget _listStreamBuilder(OrderBlocProvider bloc, Size size) {
    return StreamBuilder<List<OrderModel>>(
        stream: bloc.orderListStream,
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
          return _listBuilder(context, snapshot, orderBloc: bloc);
        });
  }

  Widget _listBuilder(
      BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot,
      {OrderBlocProvider orderBloc}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => OrderCard(
          model: snapshot.data[index],
          bloc: orderBloc,
          typeList: 'inProcess',
        ),
        childCount: snapshot.hasData ? snapshot.data.length : 0,
      ),
    );
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
