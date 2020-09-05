import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';
import 'package:scootermerchant/utilities/functions.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductBlocProvider bloc = Provider.productBlocProviderOf(context);
    final Product model = ModalRoute.of(context).settings.arguments;
    final Size size = MediaQuery.of(context).size;
    // bloc.changeProductName(model.name);
    print('model.isAvailable======================');
    print(model.isAvailable);
    // bloc.changeProductPrice(model.price);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).popAndPushNamed('editProducts'),
        ),
        title: Text('Detalles del producto', style: textStyleBtnComprar),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _containerImage(model, size),
              _containerForm(bloc, context, model)
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerImage(Product model, Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0)),
        image: DecorationImage(
          image: model.picture == null
              ? AssetImage('assets/images/no_image.png')
              : NetworkImage(model.picture),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _containerForm(
      ProductBlocProvider bloc, BuildContext context, Product product) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Datos del producto', style: textStyleDetailCardTitle),
            SizedBox(
              height: 48.0,
            ),
            _productNameStreamBuilder(bloc, product),
            SizedBox(
              height: 24.0,
            ),
            _productPriceStreamBuilder(bloc, product),
            SizedBox(
              height: 24.0,
            ),
            _switchDisponibility(bloc, product),
            // SizedBox(
            //   height: 24.0,
            // ),
            _buttonStreamBuilder(bloc, product, context)
          ],
        ),
      ),
    );
  }

  Widget _productNameStreamBuilder(ProductBlocProvider bloc, Product product) {
    return StreamBuilder(
      stream: bloc.productNameStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextFormField(
            initialValue: product.name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
              border: OutlineInputBorder(),
              labelText: 'Nombre',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeProductName);
      },
    );
  }

  Widget _productPriceStreamBuilder(ProductBlocProvider bloc, Product product) {
    return StreamBuilder(
      stream: bloc.productPriceStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        return TextFormField(
          initialValue: product.price.toString(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
              border: OutlineInputBorder(),
              labelText: 'Precio',
              errorText: snapshot.error),
          onChanged: (value) {
            bloc.changeProductPrice(double.parse(value));
          },
        );
      },
    );
  }

  Widget _switchDisponibility(ProductBlocProvider bloc, Product product) {
    // print('product.isAvailable============================');
    // print(product.isAvailable);
    return Row(
      children: <Widget>[
        Text(
          'Disponible',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        _switchStreamBuilder(bloc, product),
      ],
    );
  }

  Widget _switchStreamBuilder(ProductBlocProvider bloc, Product product) {
    return StreamBuilder(
      stream: bloc.productAvailableStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // print(MerchantPreferences().isOpen);
        return Switch(
            value: !snapshot.hasData  && snapshot.data == null
                ? product.isAvailable
                : snapshot.data,
            activeColor: colorSuccess,
            onChanged: (bool value) {
              bloc.changeProductAvailable(value);
              // print(bloc.productAvailable);
            });
      },
    );
  }

  Widget _buttonStreamBuilder(
      ProductBlocProvider bloc, Product product, BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.showLoaderStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Container(
            width: 200,
            child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Guardar datos', style: textStyleBtnComprar),
                    Visibility(
                      visible: snapshot.hasData && snapshot.data == true,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  ],
                ),
                shape: radiusButtons,
                color: primaryColor,
                onPressed: () => this._updateProduct(product, bloc, context)),
          );
        });
  }

  void _updateProduct(
      Product product, ProductBlocProvider bloc, BuildContext context) async {
    product.name = bloc.productName;
    product.price = bloc.productPrice;
    product.isAvailable = bloc.productAvailable;
    final response = await bloc.updateProduct(product: product);
    if (response['ok']) {
      // print(response['message']);
      showSnackBar(context, response['message'], colorSuccess);
    } else {
      // print(response['message']);
      showSnackBar(context, response['message'], colorDanger);
    }
  }
}
