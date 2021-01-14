import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductModel productModel;
  ProductDetailsPage(this.productModel);
  ProductBlocProvider productBlocProvider;
  Size size;

  @override
  Widget build(BuildContext context) {
    productBlocProvider = Provider.productBlocProviderOf(context);
    // final ProductModel model = ModalRoute.of(context).settings.arguments;
    size = MediaQuery.of(context).size;
    // bloc.changeProductName(model.name);
    // if (bloc.productName == null && bloc.productPrice == null) {
    productBlocProvider.changeProductName(productModel.name);
    productBlocProvider.changeProductPrice(productModel.price);
    productBlocProvider.changeProductAvailable(productModel.isAvailable);
    productBlocProvider.changeProductDescription(productModel.description);
    // }
    // bloc.changeProductPrice(model.price);
    return Scaffold(
      appBar: _customAppBar(),
      body: _customBody(context),
    );
  }

  Widget _customAppBar() {
    return AppBar(
      title: Text('Detalles del producto', style: txtStyleAppBar),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }

  Widget _customBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            _containerImage(),
            _containerForm(context),
          ],
        ),
      ),
    );
  }

  Widget _containerImage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      height: 250,
      child: FadeInImage(
        fit: BoxFit.cover,
        image: productModel.picture != null
            ? NetworkImage('${productModel.picture}')
            : AssetImage('assets/images/no_image.png'),
        placeholder: AssetImage('assets/images/no_image.png'),
      ),
    );
  }

  Widget _containerForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Text('Datos del producto', style: textStyleDetailCardTitle),
          SizedBox(height: 15.0),
          _productName(),
          SizedBox(height: 24.0),
          _productPrice(),
          SizedBox(height: 24.0),
          _switchDisponibility(),
          SizedBox(height: 10.0),
          _buttonStreamBuilder(context),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _productName() {
    return StreamBuilder(
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
            });
      },
    );
  }

  Widget _productPrice() {
    return StreamBuilder(
      stream: productBlocProvider.productPriceStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
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
    );
  }

  Widget _switchDisponibility() {
    return Row(
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
    );
  }

  Widget _switchStreamBuilder() {
    return StreamBuilder(
      stream: productBlocProvider.productAvailableStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // print(MerchantPreferences().isOpen);
        return Switch(
            value: !snapshot.hasData && snapshot.data == null
                ? productModel.isAvailable
                : snapshot.data,
            activeColor: colorSuccess,
            onChanged: (bool value) {
              productBlocProvider.changeProductAvailable(value);
              // print(bloc.productAvailable);
            });
      },
    );
  }

  Widget _buttonStreamBuilder(BuildContext context) {
    return StreamBuilder<bool>(
        stream: productBlocProvider.showLoaderStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Container(
            width: size.width,
            child: FloatingActionButton.extended(
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
                onPressed: () => this._updateProduct(context)),
          );
        });
  }

  void _updateProduct(BuildContext context) async {
    productModel.name = productBlocProvider.productName;
    productModel.price = productBlocProvider.productPrice;
    productModel.isAvailable = productBlocProvider.productAvailable;
    // print(product.price);
    if (productModel.name.isEmpty || productModel.price == null) {
      showSnackBar(context, 'Todos los campos son obligatorios', colorDanger);
      return;
    }
    final response =
        await productBlocProvider.updateProduct(product: productModel);
    if (response['ok']) {
      // print(response['message']);
      showSnackBar(context, response['message'], colorSuccess);
      Navigator.pop(context);
    } else {
      // print(response['message']);
      showSnackBar(context, response['message'], colorDanger);
    }
  }
}
