import 'package:flutter/material.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  const ProductCard({Key key, this.product, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: index == 0
          ? EdgeInsets.all(16.0)
          : EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
      child: InkWell(
        child: Row(
          children: <Widget>[_containerImage(product), _containerInfo(product)],
        ),
        onTap: () => this._navigateToDetails(context, product),
      ),
    );
  }

  Widget _containerImage(Product product) {
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

  Widget _containerInfo(Product product) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              product.name,
              style: textStyleTitleListTile,
            ),
            Text(
              'Precio: ${product.price}',
              style: textStyleSubtitleListTile,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Product model) async {
    await Navigator.of(context)
        .pushReplacementNamed('productDetails', arguments: model);
  }
}
