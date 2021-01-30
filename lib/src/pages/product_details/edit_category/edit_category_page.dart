import 'package:flutter/material.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';

class EditCategoryPage extends StatelessWidget {
  MenuCategoriesModel categories;
  EditCategoryPage({this.categories});
  // const EditCategoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _customBody(),
    );
  }

  Widget _customAppBar() {
    return SliverAppBar(
      title: Text('Editar categoría', style: txtStyleAppBar),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
    );
  }

  Widget _customBody() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        _customAppBar(),
        _nameCategory(),
        _obligatorySwitch(),
        _minOptionsChoose(),
        _maxOptionsChoose(),
        // _showListOptions(),
      ],
    );
  }

  Widget _nameCategory() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: TextFormField(
          initialValue: categories.name,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
            border: OutlineInputBorder(),
            labelText: 'Nombre de la categoría',
          ),
          onChanged: (value) {
            // productBlocProvider.changeProductPrice(double.parse(value));
          },
        ),
      ),
    );
  }

  Widget _obligatorySwitch() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Text('Obligatorio',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            Switch(
              value: categories.isObligatory,
              activeColor: colorSuccess,
              onChanged: (bool value) {
                // productBlocProvider.changeStatusOption(option, menu, value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _minOptionsChoose() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: StreamBuilder(
          // stream: productBlocProvider.productPriceStream,
          builder: (context, snapshot) {
            return TextFormField(
              initialValue: categories.minOptionsChoose.toString(),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  border: OutlineInputBorder(),
                  labelText: 'Minino',
                  errorText: snapshot.error),
              onChanged: (value) {
                // productBlocProvider.changeProductPrice(double.parse(value));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _maxOptionsChoose() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          initialValue: categories.minOptionsChoose.toString(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
            border: OutlineInputBorder(),
            labelText: 'Máximo',
            // errorText: snapshot.error
          ),
          onChanged: (value) {
            // productBlocProvider.changeProductPrice(double.parse(value));
          },
        ),
      ),
    );
  }
}
