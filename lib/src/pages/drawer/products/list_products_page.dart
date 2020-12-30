import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/pages/drawer/products/custom_search.dart';
import 'package:scootermerchant/src/pages/drawer/products/product_card.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class ListProductsPage extends StatefulWidget {
  // const ChangeProductPage({Key key}) : super(key: key);
  @override
  _ListProductsPageState createState() => _ListProductsPageState();
}

class _ListProductsPageState extends State<ListProductsPage> {
  ProductBlocProvider productBlocProvider;

  Size size;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.addListener(() {
        if (_controller.position.pixels ==
            _controller.position.maxScrollExtent) {
          // print('entro');
          productBlocProvider.getProducts();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productBlocProvider = Provider.productBlocProviderOf(context);
    size = MediaQuery.of(context).size;
    productBlocProvider.getProducts();
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          _customAppBar(),
          _listProducts(),
          SliverToBoxAdapter(
            child: StreamBuilder<bool>(
              stream: productBlocProvider.showLoaderStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200],
                    highlightColor: Colors.grey[100],
                    child: _itemSkeleton(),
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),

      // _createListStreamBuilder(),
    );
  }

  Widget _customAppBar() {
    return SliverAppBar(
      floating: true,
      brightness: Brightness.light,
      title: Text(
        'Lista de productos',
        style: txtStyleAppBar,
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_outlined),
          onPressed: () =>
              showSearch(context: context, delegate: CustomSearch()),
        ),
      ],
    );
  }

  Widget _listProducts() {
    return StreamBuilder<List<ProductModel>>(
      stream: productBlocProvider.productListStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[100],
              child: _itemSkeleton(),
            ),
          );
        } else if (snapshot.data.length == 0) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No hay ningun producto.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductItem(snapshot.data[index]),
              childCount: snapshot.hasData ? snapshot.data.length : 0,
            ),
          );
          // return _listBuilder(snapshot);
        }
      },
    );
  }

  Widget _itemSkeleton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _listItemSkeleton(),
      ),
    );
  }

  List<Widget> _listItemSkeleton() {
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
