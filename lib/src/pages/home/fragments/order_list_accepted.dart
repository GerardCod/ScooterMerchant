import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/order_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/blocs/timezone_bloc_provider.dart';
import 'package:scootermerchant/src/models/order_model.dart';
import 'package:scootermerchant/src/widgets/card_item.dart';
import 'package:shimmer/shimmer.dart';

class OrderListAccepted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    final TimeZoneBlocProvider timeZoneBlocProvider =
        Provider.timeZoneBlocProviderOf(context);
    final size = MediaQuery.of(context).size;
    // bloc.changeOrderList(null);
    // if (bloc.orderListAccepted == null) {
    bloc.getOrdersAccepted(status: '15', ordering: 'created');
    // }
    return StreamBuilder<bool>(
        stream: bloc.loaderListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return SliverToBoxAdapter(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: _itemSkeleton(size),
                ),
              );
            }
            return _listStreamBuilder(bloc, size, timeZoneBlocProvider);
          }
          return SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: _itemSkeleton(size),
            ),
          );
        });
  }

  Widget _listStreamBuilder(
      OrderBlocProvider bloc, Size size, TimeZoneBlocProvider time) {
    return StreamBuilder<List<OrderModel>>(
        stream: bloc.orderListAcceptedStream,
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
                  'No hay ningún pedido en preparación.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return _listBuilder(context, snapshot, orderBloc: bloc, time: time);
        });
  }

  Widget _listBuilder(
      BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot,
      {OrderBlocProvider orderBloc, TimeZoneBlocProvider time}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => CardItem(snapshot.data[index], time),
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
