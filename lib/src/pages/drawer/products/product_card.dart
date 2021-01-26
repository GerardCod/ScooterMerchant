import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/src/pages/product_details/product_details_page.dart';

class ProductItem extends StatelessWidget {
  ProductModel product;
  ProductItem(this.product);
  ProductBlocProvider productBlocProvider;

  @override
  Widget build(BuildContext context) {
    productBlocProvider = Provider.productBlocProviderOf(context);
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.only(bottom:2),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('\u0024' + product.price.toStringAsFixed(2)),
        onTap: () => _navigateToDetails(context),
        leading: _imageProduct(),
      ),
    );
  }

  Widget _imageProduct() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        color: Colors.white,
        height: 60,
        width: 60,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: product.picture != null
              ? NetworkImage('${product.picture}')
              : AssetImage('assets/images/no_image.png'),
          placeholder: AssetImage('assets/images/no_image.png'),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) async {
    productBlocProvider.cleanProductState();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailsPage(product)));
    // Navigator.push(context, ProductDetailsPage(product))
    //     .pushNamed('productDetailsPage', arguments: product);
  }
}
