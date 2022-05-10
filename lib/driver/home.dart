import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stalker/driver/driverScreen.dart';
import 'package:stalker/driver/profile.dart';
import 'package:stalker/helpers/screen_navigation.dart';
import 'package:stalker/providers/user.dart';
import 'package:stalker/shared_screen/show_all_buss.dart';
import 'package:stalker/shared_screen/show_all_companies.dart';
import 'package:stalker/shared_screen/wellcome.dart';

class HomeDriverScreen extends StatefulWidget {
  @override
  _HomeDriverScreenState createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetAppBarTitle = <Widget>[

    Text(
      'All Bus',
    ),
    Text(
      'Driver Screen',
    ),
    Text(
      'All Companies',
    ),Text(
      'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: (_selectedIndex == 1)
          ? null
          : AppBar(
              leading: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  authProvider.signOut();
                  changeScreenReplaceUntil(context, SelectAccount());
                },
              ),
              title: _widgetAppBarTitle.elementAt(_selectedIndex),
              centerTitle: true,
            ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: FancyBottomNavigation(
        barBackgroundColor: Colors.blue,
        textColor: Colors.white,
        circleColor: Colors.red[400],
        inactiveIconColor: Colors.white,
        initialSelection: 1,
        tabs: [
          TabData(iconData: Icons.directions_bus_sharp, title: "Bus"),
          TabData(iconData: Icons.drive_eta, title: "Driver"),
          TabData(iconData: Icons.business_sharp, title: "Companies"),
          TabData(iconData: Icons.person, title: "Profile")
        ],
        onTabChangedListener: _onItemTapped,
      ),
    );
  }

  List<Widget> _widgetOptions = <Widget>[
    ShowBuss(),
    DriverScreen(),
    ShowCompanies(),
    Profile()
  ];
}
