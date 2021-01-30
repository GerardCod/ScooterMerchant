import 'package:flutter/material.dart';
import 'package:scootermerchant/src/models/product_model.dart';
import 'package:scootermerchant/utilities/constants.dart';


class OptionsPage extends StatelessWidget {
  // const OptionsPage({Key key}) : super(key: key);
  MenuCategoriesModel categories;

  OptionsPage(this.categories);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _itemOption(context, categories.options[index]),
        childCount: categories.options.length,
      ),
    );
  }

  Widget _itemOption(BuildContext context, OptionsModel option) {
    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: ListTile(
        title: Text(option.name),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => _showAlert(context, option),
      ),
    );
  }

  void _showAlert(BuildContext context, OptionsModel option) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Opción'),
          content: Wrap(
            children: [
              _nameOption(),
              _priceOption(),
              _disponibilityOption(),
            ],
          ),
          // title: Text('Información incorrecta'),
          // content: Text(mensaje),
          actions: <Widget>[
            RaisedButton(
              color: accentColor,
              child: Text('Aceptar'),
              onPressed: () {},
              // onPressed: () => productBlocProvider.changeStatusOption(
              //     option, menuOption, isAvailable, productModel.id),
            ),
            RaisedButton(
              color: Colors.red,
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _nameOption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder(
        // stream: productBlocProvider.productPriceStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: categories.name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16.0),
                border: OutlineInputBorder(),
                labelText: 'Nombre de la opción',
                errorText: snapshot.error),
            onChanged: (value) {
              // productBlocProvider.changeProductPrice(double.parse(value));
            },
          );
        },
      ),
    );
  }

  Widget _priceOption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder(
        // stream: productBlocProvider.productPriceStream,
        builder: (context, snapshot) {
          return TextFormField(
            initialValue: categories.name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16.0),
                border: OutlineInputBorder(),
                labelText: 'Nombre de la opción',
                errorText: snapshot.error),
            onChanged: (value) {
              // productBlocProvider.changeProductPrice(double.parse(value));
            },
          );
        },
      ),
    );
  }

  Widget _disponibilityOption() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('Es obligatorio'),
          Switch(
            value: categories.isObligatory,
            activeColor: colorSuccess,
            onChanged: (bool value) {
              // productBlocProvider.changeStatusOption(option, menu, value);
            },
          ),
        ],
      ),
    );
  }
}