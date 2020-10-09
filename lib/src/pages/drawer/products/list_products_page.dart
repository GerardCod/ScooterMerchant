import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/pages/drawer/products/product_card.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class ListProductsPage extends StatelessWidget {
  // const ChangeProductPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductBlocProvider bloc = Provider.productBlocProviderOf(context);
    final Size size = MediaQuery.of(context).size;
    bloc.getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de productos',
          style: textStyleBtnComprar,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _createListStreamBuilder(bloc, size),
    );
  }

  Widget _createListStreamBuilder(ProductBlocProvider bloc, Size size) {
    return StreamBuilder<List<Product>>(
      stream: bloc.productListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (!snapshot.hasData) {
          return SingleChildScrollView(
            child: Container(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: _itemSkeleton(size),
              ),
            ),
          );
        } else if (snapshot.data.length == 0) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No hay ningun producto.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return _listBuilder(bloc, snapshot);
        }
      },
    );
  }

  Widget _listBuilder(
      ProductBlocProvider bloc, AsyncSnapshot<List<Product>> snapshot) {
    return ListView.builder(
      itemBuilder: (BuildContext contex, int index) {
        return ProductCard(
          product: snapshot.data[index],
          index: index,
          bloc: bloc,
        );
      },
      itemCount: snapshot.hasData ? snapshot.data.length : 0,
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
          height: 50.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }
}
