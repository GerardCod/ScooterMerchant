import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/product_bloc_provider.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  // final int index;
  // const ProductCard({Key key, this.product, this.index, this.bloc})
  // : super(key: key);
  ProductItem(this.product);
  ProductBlocProvider productBlocProvider;

  @override
  Widget build(BuildContext context) {
    productBlocProvider = Provider.productBlocProviderOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Ink(
        color: Colors.white,
        child: ListTile(
          title: Text(product.name),
          subtitle: Text('\u0024' + product.price.toStringAsFixed(2)),
          onTap: () => _navigateToDetails(context),
          leading: _imageProduct(),
        ),
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

  Widget _containerImage(ProductModel product) {
    return Container(
      width: 60.0,
      height: 60.0,
      child: product.picture == null
          ? Image(
              image: AssetImage('assets/images/no_image.png'),
              fit: BoxFit.cover,
            )
          : Image(
              image: NetworkImage(product.picture),
              fit: BoxFit.cover,
            ),
    );
  }

  void _navigateToDetails(BuildContext context) async {
    productBlocProvider.cleanProductState();
    await Navigator.of(context)
        .pushNamed('productDetailsPage', arguments: product);
  }
}
