import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  // const NavDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                child: Text(
                  'Nombre Comercio',
                  style: TextStyle( fontSize: 25),
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
              leading: Icon(Icons.input),
              title: Text('Configuración'),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Ayuda'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }
}
