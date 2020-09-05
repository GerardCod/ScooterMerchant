import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/merchant_model.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';
import 'package:scootermerchant/utilities/constants.dart';

class NavDrawer extends StatelessWidget {
  // const NavDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = Provider.of(context);
    final MerchantPreferences prefs = new MerchantPreferences();
    final MerchantModel merchant = prefs.merchant;
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                child: Text(
                  merchant.merchantName,
                  style: TextStyle(fontSize: 25),
                ),
                // decoration: BoxDecoration(
                //     color: Colors.green,
                //     image: DecorationImage(
                //         fit: BoxFit.fill,
                //         image: AssetImage('assets/images/cover.jpg'))
                //         ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: _switchDisponibility(context, bloc),
            ), 
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () => {Navigator.pushNamed(context, 'settings')},
            ),
            ListTile(
              leading: Icon(Icons.mode_edit),
              title: Text('Editar productos'),
              onTap: () => this._navigateToProductListChange(context),
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Ayuda'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () => this._logOut(bloc, context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logOut(LoginBloc bloc, BuildContext context) async {
    if (await bloc.logout()) {
      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
    }
  }

  void _navigateToProductListChange(BuildContext context) {
    Navigator.of(context).popAndPushNamed('editProducts');
  }

  Widget _switchDisponibility(BuildContext context, LoginBloc bloc) {
    return Row(
      children: <Widget>[
        Text(
          'Abierto',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        _switchStreamBuilder(bloc),
      ],
    );
  }

  Widget _switchStreamBuilder(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.availabilityStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // print(MerchantPreferences().isOpen);
        return Switch(
          value: snapshot.hasData && MerchantPreferences().isOpen != null
              ? snapshot.data
              : MerchantPreferences().isOpen,
          activeColor: colorSuccess,
          onChanged: (bool value) => _updateAvailability(value, bloc, context),
        );
      },
    );
  }

  Future<void> _updateAvailability(
      bool value, LoginBloc bloc, BuildContext context) async {
    final response = await bloc.updateAvailability(isOpen: value);
    print(response);
  }
}
