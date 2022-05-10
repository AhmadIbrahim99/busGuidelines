import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:stalker/helpers/screen_navigation.dart';
import 'package:stalker/shared_screen/contact.dart';
import 'package:stalker/sign_screen/login.dart';
import 'package:stalker/user_screen/realTimeMap.dart';

import 'show_all_buss.dart';
import 'show_all_companies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
enum PopMenu { Help, About, Contact, Settings }
class _HomeScreenState extends State<HomeScreen> {


  int _selectedIndex = 1;

  static const List<Widget> _widgetAppBarTitle = <Widget>[
   /* Text(
      'Bus Guide',
    ),*/
    Text(
      'All Bus',
    ),
    Text(
      'Live BroadCast Map',
    ),
    Text(
      'All Companies',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.login),onPressed: () {
          changeScreen(context, LoginScreen());
        },),
        actions: [
          _popUpMenu(context),
        ],
        title: _widgetAppBarTitle.elementAt(_selectedIndex),
        centerTitle: true,
      ),
      //drawer:UserDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: FancyBottomNavigation(
          barBackgroundColor: Colors.blue,
          textColor: Colors.white,
          circleColor: Colors.red[400],
          inactiveIconColor: Colors.white,
          initialSelection: 1,
          tabs: [
            TabData(iconData: Icons.directions_bus_sharp, title: "Bus"),
            TabData(iconData: Icons.near_me_sharp, title: "Near Bus"),
            TabData(iconData: Icons.business_sharp, title: "Companies")
          ],
          onTabChangedListener: _onItemTapped,
        ),
      /*bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me_sharp),
            label: 'Near Bus',
            backgroundColor: Colors.blue,
          ),
         BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_sharp),
            label: 'Buss',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Companies',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreenAccent,
        onTap: _onItemTapped,
      ),*/
    );
  }

  List<Widget> _widgetOptions = <Widget>[

   // Text('Home Screen'),
    ShowBuss(),
    LiveMapBroadcast(),
    ShowCompanies(),
  ];
}

Widget _popUpMenu(BuildContext context) {
  return PopupMenuButton<PopMenu>(
    itemBuilder: (context) {
      return [
        PopupMenuItem<PopMenu>(
            value: PopMenu.Help, child: Text('Help')),
        PopupMenuItem<PopMenu>(
            value: PopMenu.About, child: Text('About App')),
        PopupMenuItem<PopMenu>(
            value: PopMenu.Contact, child: Text('Contact')),
        PopupMenuItem<PopMenu>(
            value: PopMenu.Settings, child: Text('Settings')),
      ];
    },
    onSelected: (PopMenu menu) {
      switch (menu) {
        case PopMenu.Help:

          break;

        case PopMenu.About:

          break;

        case PopMenu.Contact:
          changeScreen(context, Contact());
          break;

        case PopMenu.Settings:

          break;
      }
    },
    icon: Icon(Icons.more_vert),
  );
}