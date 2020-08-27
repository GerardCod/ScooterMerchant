import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scootermerchant/src/pages/home/fragments/order_history.dart';
import 'package:scootermerchant/src/pages/home/fragments/order_list.dart';
import 'package:scootermerchant/src/pages/home/fragments/order_list_accepted.dart';
import 'package:scootermerchant/src/widgets/nav_drawer_widget.dart';
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
    OrderHistory(),
  ];
  final MerchantPreferences _prefs = MerchantPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              'Scooter',
              style: textStyleForAppBar,
            ),
            floating: false,
            pinned: true,
            expandedHeight: 160,
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    image: DecorationImage(
                      image: NetworkImage(_prefs.merchant.picture),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
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
      extendBody: true,
    );
    //  Scaffold(
    //   endDrawer: NavDrawer(),
    //   appBar:CustomAppBar(),
    //   body: Column(
    //     // shrinkWrap: true,
    //     children: <Widget>[
    // Header(),
    //       Expanded(child: _pages.elementAt(_currentPage),),
    //     ],
    //   ),
    //   bottomNavigationBar: _bottomNavigationBar(),
    //   extendBody: true,
    // );
  }

  Widget _bottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      child: BottomNavigationBar(
        elevation: 10.0,
        backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
        items: [
          _bottomNavigationBarItem(Icons.add_to_home_screen, 'Entrantes'),
          _bottomNavigationBarItem(Icons.fastfood, 'Aceptados'),
          _bottomNavigationBarItem(Icons.history, 'Historial')
        ],
        onTap: _onTap,
        selectedItemColor: primaryColor,
        currentIndex: _currentPage,
      ),
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

  // Widget _customAppBar(){
  //   return AppBar(
  //     title: Text('Title'),
  //   );
  // }
}
