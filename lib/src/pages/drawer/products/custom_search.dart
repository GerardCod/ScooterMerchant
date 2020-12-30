import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/pages/drawer/products/product_card.dart';
import 'package:scootermerchant/src/pages/shared/no_data_page.dart';
import 'package:shimmer/shimmer.dart';

class CustomSearch extends SearchDelegate<ProductModel> {
  // String categoryId;
  // String subCategoryId;
  // String categoryName;
  // CustomSearchDelegate(this.categoryId, this.subCategoryId, this.categoryName);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => this.query = '')
    ];
  }

  Size size;
  ProductBlocProvider productBlocProvider;
  // SearchInCategoryPageBloc searchInCategoryPageBloc;
  // MerchantMenuPageLevel3Bloc menuPageLevel3Bloc;
  // MerchantMenuPageLevel2Bloc menuPageLevel2Bloc;
  // OrderPurchasePageBloc orderPurchasePageBloc;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Para buscar los resultados
    size = MediaQuery.of(context).size;
    productBlocProvider = Provider.productBlocProviderOf(context);
    productBlocProvider.searchProducts(query);

    // menuPageLevel2Bloc = Provider.merchantMenuPageLevel2Bloc(context);
    // menuPageLevel3Bloc = Provider.merchantSuperMarketPageBloc(context);
    // searchInCategoryPageBloc = Provider.searchInCategoryPageBloc(context);
    // orderPurchasePageBloc = Provider.orderPurchasePageBloc(context);
    // Map<String, dynamic> infoMerchant = {
    //   'search': query,
    //   'category': categoryId,
    //   'subcategory': subCategoryId
    // };
    // searchInCategoryPageBloc.searchMerchant = infoMerchant;
    return StreamBuilder<List<ProductModel>>(
        stream: productBlocProvider.listProductsSearchStream,
        builder: (context, snapshot) {
          if (productBlocProvider.loaderProductsSearch == null ||
              productBlocProvider.loaderProductsSearch) {
            return SingleChildScrollView(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[100],
                child: _itemSkeleton(),
              ),
            );
          }

          if (snapshot.data != null && snapshot.data.length > 0) {
            return ListView.builder(
                // controller: _scrollController,
                itemCount: snapshot.data.length,
                // itemCount: snapshot.data.length,
                itemBuilder: (BuildContext contex, int index) {
                  // _count = snapshot.data["count"];
                  // final address = snapshot.data[index];
                  return ProductItem(snapshot.data[index]);
                });
          } else if (snapshot.data.length != null &&
              snapshot.data.length == 0) {
            return NoDataPage('No se encontró el producto $query.');
          } else {
            return Text('Error inesperado');
          }
        });
  }

  Widget _itemSkeleton() {
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
          height: 50.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel => 'Busca el producto';
}
