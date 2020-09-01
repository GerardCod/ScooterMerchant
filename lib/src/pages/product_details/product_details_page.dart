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
    return Scaffold(
      appBar: AppBar(
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
            _productStockStreamBuilder(bloc, product),
            SizedBox(
              height: 24.0,
            ),
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
          onChanged: bloc.changeProductName,
        );
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
            onChanged: (String value) {
              bloc.changeProductPrice(double.parse(value));
            },
          );
        });
  }

  Widget _productStockStreamBuilder(ProductBlocProvider bloc, Product product) {
    return StreamBuilder(
        stream: bloc.productStockStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return TextFormField(
            initialValue: product.stock.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16.0),
                border: OutlineInputBorder(),
                labelText: 'Stock',
                errorText: snapshot.error),
            onChanged: (String value) {
              bloc.changeProductStock(int.parse(value));
            },
          );
        });
  }

  Widget _buttonStreamBuilder(
      ProductBlocProvider bloc, Product product, BuildContext context) {
    return StreamBuilder(
        stream: bloc.validateProductInformation,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return RaisedButton(
            child: Text('Guardar datos', style: textStyleBtnComprar),
            shape: radiusButtons,
            color: primaryColor,
            onPressed: snapshot.hasData
                ? () => this._updateProduct(product, bloc, context)
                : null,
          );
        });
  }

  void _updateProduct(
      Product product, ProductBlocProvider bloc, BuildContext context) async {
    final response = await bloc.updateProduct(product: product);
    if (response['ok']) {
      showSnackBar(context, response['message'], colorSuccess);
    } else {
      showSnackBar(context, response['message'], colorDanger);
    }
  }
}
