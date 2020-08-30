import 'package:flutter/material.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      shape: radiusButtons,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.25),
      child: Row(
        children: <Widget>[_containerImage(product), _containerInfo(product)],
      ),
    );
  }

  Widget _containerImage(Product product) {
    return Container(
      width: 48.0,
      height: 48.0,
      child: Image(
        image: NetworkImage(product.picture?.toString()),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _containerInfo(Product product) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              product.name,
              style: textStyleNeed,
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
}
