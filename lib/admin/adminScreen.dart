import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:stalker/admin/add_company.dart';
import 'package:stalker/admin/add_edit_buss.dart';
import 'package:stalker/admin/companies.dart';
import 'package:stalker/admin/buss.dart';
import 'package:stalker/admin/radar.dart';
import 'package:stalker/helpers/screen_navigation.dart';
import 'package:stalker/providers/user.dart';
import 'package:stalker/shared_screen/home.dart';
import 'package:stalker/sign_screen/registration.dart';
import 'package:stalker/widgets/myItems.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreen createState() => _AdminScreen();
}

class _AdminScreen extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider= Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin DashBoard"),
        centerTitle: true,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Admin',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
            ),
            ListTile(
              title: Text('Add Company'),
              onTap: () {
                Navigator.of(context).pop();
                changeScreen(context, AddCompany());
              },
            ),
            ListTile(
              title: Text('Add Buss'),
              onTap: () {
                Navigator.of(context).pop();
                changeScreen(context, AddEditBuss());
              },
            ),
            ListTile(
              title: Text('All Company'),
              onTap: () {
                Navigator.of(context).pop();
                changeScreen(context, AllCompanies());
              },
            ),
            ListTile(
              title: Text('All Buss'),
              onTap: () {
                Navigator.of(context).pop();
                changeScreen(context, AllBuss());
              },
            ),
            ListTile(
              title: Text('Add Driver'),
              onTap: () {
                authProvider.signOut();
                Navigator.of(context).pop();
                changeScreen(context, RegistrationScreen());
              },
            ),
            ListTile(
              title: Text('Radar'),
              onTap: () {
                authProvider.signOut();
                Navigator.of(context).pop();
                changeScreen(context, Radar());
              },
            ),
            ListTile(
              title: Text('Sign out'),
              onTap: () {
                authProvider.signOut();
                changeScreenReplaceUntil(context, HomeScreen());
              },
            ),

          ],
        ),
      ),
      body: _dashBoard(),
    );
  }
  Widget _dashBoard(){
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        myItems(Icons.person, "Add Driver", Colors.deepOrangeAccent, context,RegistrationScreen()),
        myItems(Icons.directions_bus, "Add Bus", Colors.orange, context, AddEditBuss()),
        myItems(Icons.business, "Add company", Colors.pink, context, AddCompany()),
        myItems(Icons.directions_bus_sharp, "Buses", Colors.green, context, AllBuss()),
        myItems(Icons.business_sharp, "Companies", Colors.blue, context, AllCompanies()),
        myItems(Icons.radar, "Radar", Colors.yellow, context, Radar()),
      ],
      staggeredTiles: [
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(1, 300.0),
        StaggeredTile.extent(1, 150.0),
      ],


    );
  }
}
