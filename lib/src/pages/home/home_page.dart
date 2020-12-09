import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scootermerchant/src/pages/home/fragments/order_list_ready.dart';
import 'package:scootermerchant/src/pages/home/fragments/order_list.dart';
import 'package:scootermerchant/src/pages/home/fragments/order_list_accepted.dart';
import 'package:scootermerchant/src/pages/drawer/nav_drawer_widget.dart';
import 'package:scootermerchant/utilities/constants.dart';
import '../../preferences/merchant_preferences.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  List<Widget> _pages = [
    OrderList(),
    OrderListAccepted(),
    OrderListReady(),
    // OrderHistory(),
  ];
  final MerchantPreferences _prefs = MerchantPreferences();

  @override
  Widget build(BuildContext context) {
    // final OrderBlocProvider bloc = Provider.orderBlocProviderOf(context);
    // bloc.changeOrderList(null);
    return Scaffold(
      endDrawer: NavDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // actions: <Widget>[_switchDisponibility(context, bloc)],
            // title: Text(
            //   'SCOOTER',
            //   style: textStyleForAppBar,
            // ),
            floating: false,
            pinned: true,
            expandedHeight: 120,
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                  ),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        _prefs.merchant.merchantName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Arial',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                              color: Color(0xff808080),
                            ),
                          ],
                          
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _pages.elementAt(_currentPage),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      // extendBody: true,
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      // elevation: 10.0,
      // backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      items: [
        _bottomNavigationBarItem(Icons.add_to_home_screen, 'Entrantes'),
        _bottomNavigationBarItem(Icons.fastfood, 'En preparación'),
        _bottomNavigationBarItem(Icons.motorcycle, 'Listos'),
        // _bottomNavigationBarItem(Icons.history, 'Historial'),
      ], type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      onTap: _onTap,
      selectedItemColor: primaryColor,
      currentIndex: _currentPage,
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), title: Text(label));
  }

  void _onTap(int index) {
    setState(() {
      this._currentPage = index;
    });
  }
}
