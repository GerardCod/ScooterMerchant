import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductBlocProvider bloc = Provider.productBlocProviderOf(context);
    return Container(
      child: Center(
        child: Text('Details product'),
      ),
    );
  }
}
