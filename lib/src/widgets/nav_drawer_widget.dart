import 'package:flutter/material.dart';
import 'package:scootermerchant/src/blocs/login_bloc.dart';
import 'package:scootermerchant/src/blocs/provider.dart';
import 'package:scootermerchant/src/models/merchant_model.dart';
import 'package:scootermerchant/src/preferences/merchant_preferences.dart';

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
}
