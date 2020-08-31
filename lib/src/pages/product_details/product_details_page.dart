import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

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
}
