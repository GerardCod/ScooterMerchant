import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/pages/product_details/edit_category/edit_category_page.dart';
import 'package:scootermerchant/src/pages/product_details/product_image.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductModel productModel;
  ProductDetailsPage(this.productModel);
  ProductBlocProvider productBlocProvider;
  Size size;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final picker = ImagePicker();
  // File _image;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    productBlocProvider = Provider.productBlocProviderOf(context);

    productBlocProvider.changeProductName(productModel.name);
    productBlocProvider.changeProductPrice(productModel.price);
    productBlocProvider.changeProductAvailable(productModel.isAvailable);
    productBlocProvider.changeProductDescription(productModel.description);
    productBlocProvider.changeListMenuCategories(productModel.menuCategories);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: _customBody(context),
      floatingActionButton: _customFloating(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _customAppBar() {
    return SliverAppBar(
      floating: true,
      title: Text('Detalles del producto', style: txtStyleAppBar),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  Widget _customBody(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        _customAppBar(),
        ProductImagePage(productModel: productModel),
        _switchDisponibility(),
        _productName(),
        _productPrice(),
        SliverToBoxAdapter(child: SizedBox(height: 10)),
        _textCategories(),
        _showListMenuCategories(),
        // _expansionTile(),
        SliverToBoxAdapter(child: SizedBox(height: 100))
      ],
    );
  }

  Widget _switchDisponibility() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            StreamBuilder<bool>(
                stream: productBlocProvider.productAvailableStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data ? 'Disponible' : 'No disponible',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      productModel.isAvailable ? 'Disponible' : 'No disponible',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                }),
            SizedBox(
              width: 8.0,
            ),
            _switchStreamBuilder(),
          ],
        ),
      ),
    );
  }

  Widget _switchStreamBuilder() {
    return StreamBuilder(
      stream: productBlocProvider.productAvailableStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Switch(
          value: !snapshot.hasData && snapshot.data == null
              ? productModel.isAvailable
              : snapshot.data,
          activeColor: colorSuccess,
          onChanged: (bool value) {
            productBlocProvider.changeProductAvailable(value);
            // print(bloc.productAvailable);
          },
        );
      },
    );
  }

  Widget _productName() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: productBlocProvider.productNameStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return TextFormField(
              initialValue: productModel.name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16.0),
                border: OutlineInputBorder(),
                labelText: 'Nombre',
                errorText: snapshot.error,
              ),
              onChanged: (value) {
                productBlocProvider.changeProductName(value);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _productPrice() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder(
          stream: productBlocProvider.productPriceStream,
          builder: (context, snapshot) {
            return TextFormField(
              initialValue: productModel.price.toStringAsFixed(2),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(),
                  labelText: 'Precio',
                  errorText: snapshot.error),
              onChanged: (value) {
                productBlocProvider.changeProductPrice(double.parse(value));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _textCategories() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Categorías',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _showListMenuCategories() {
    return StreamBuilder<List<MenuCategoriesModel>>(
      stream: productBlocProvider.listMenuCategoriesStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _showItemMenuCategories(snapshot.data[index], index, context),
              childCount: snapshot.data.length,
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200],
            highlightColor: Colors.grey[100],
            child: _itemSkeleton(),
          ),
        );
      },
    );
  }

  Widget _showItemMenuCategories(
      MenuCategoriesModel menuCategory, int category, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => EditCategoryPage(
                      categories: menuCategory,
                    ))),
        title: Text(menuCategory.name),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  // Widget _showListOptions(
  //     List<OptionsModel> options, MenuCategoriesModel menu) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: options.length,
  //     itemBuilder: (context, index) => _itemOption(options[index], menu),
  //   );
  // }

  // Widget _itemOption(OptionsModel option, MenuCategoriesModel menu) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 8),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(option.name),
  //         StreamBuilder<OptionsModel>(
  //           stream: productBlocProvider.optionAvailableStream,
  //           builder: (context, snapshot) {
  //             return Switch(
  //               value: _getValueSwitch(snapshot, option),
  //               activeColor: colorSuccess,
  //               onChanged: (bool value) {
  //                 _showAlert(
  //                     context,
  //                     'Vas a cambiar el estado de una opción del producto, ¿Estás de acuerdo?',
  //                     option,
  //                     menu,
  //                     value);
  //                 // productBlocProvider.changeStatusOption(option, menu, value);
  //               },
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // bool _getValueSwitch(
  //     AsyncSnapshot<OptionsModel> snapshot, OptionsModel option) {
  //   if (snapshot.hasData) {
  //     if (snapshot.data == option) {
  //       return snapshot.data.isAvailable;
  //     }
  //     return option.isAvailable;
  //   } else {
  //     return true;
  //   }
  // }

  Widget _customFloating(BuildContext context) {
    return StreamBuilder<bool>(
      stream: productBlocProvider.showLoaderStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Container(
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FloatingActionButton.extended(
              backgroundColor:
                  snapshot.hasData && snapshot.data ? Colors.grey : accentColor,
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Guardar datos', style: textStyleBtnComprar),
                  Visibility(
                    visible: snapshot.hasData && snapshot.data,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              onPressed: snapshot.hasData && snapshot.data
                  ? null
                  : () => _updateProduct(context)),
        );
      },
    );
  }

  void _updateProduct(BuildContext context) async {
    productModel.name = productBlocProvider.productName;
    productModel.price = productBlocProvider.productPrice;
    productModel.isAvailable = productBlocProvider.productAvailable;
    // productModel.menuCategories = productBlocProvider.listMenuCategories;
    // productModel.picture = productBlocProvider.imagePicked.path;

    if (productModel.name.isEmpty || productModel.price == null) {
      _scaffoldKey.currentState.showSnackBar(
          _createSnackBar(Colors.red, 'Rellena los campos vacios.'));
    }
    final response = await productBlocProvider.updateProduct(
        product: productModel, imagePicked: productBlocProvider.imagePicked);
    if (response['ok']) {
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.green, response['message']))
          .closed
          .then((value) {
        productBlocProvider.changeShowLoader(false);
        productBlocProvider.changeProductList(null);
        productBlocProvider.getProducts();

        Navigator.pop(context);
      });
    } else {
      _scaffoldKey.currentState
          .showSnackBar(_createSnackBar(Colors.red, response['message']))
          .closed
          .then((value) {
        productBlocProvider.changeShowLoader(false);
        Navigator.pop(context);
      });
    }
  }

  _createSnackBar(Color color, String message) {
    return SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: color,
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
          height: 65.0,
          color: Colors.white,
        ),
      );
    }
    return listings;
  }
}
