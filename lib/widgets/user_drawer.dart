import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stalker/driver/driverScreen.dart';
import 'package:stalker/driver/home.dart';
import 'package:stalker/helpers/commons.dart';
import 'package:stalker/helpers/screen_navigation.dart';
import 'package:stalker/providers/user.dart';
import 'package:stalker/shared_screen/home.dart';
import 'package:stalker/shared_screen/show_all_buss.dart';
import 'package:stalker/shared_screen/show_all_companies.dart';
import 'package:stalker/sign_screen/login.dart';

import 'custom_text.dart';

class DriverDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
              accountName: CustomText(text: UserProvider.userModel.name,color: white,),
              accountEmail: CustomText(text: UserProvider.userModel.email,color: Colors.white70,)
      ),

          ListTile(
            onTap: (){changeScreen(context, HomeDriverScreen()); },
            leading: Icon(Icons.home),
            title: CustomText(text: "Home",),
          ),
          ListTile(
            onTap: (){changeScreen(context, DriverScreen());},
            leading: Icon(Icons.map),
            title: CustomText(text: "Driver Screen",),
          ),
          ListTile(
            onTap: (){changeScreen(context, ShowBuss());},
            leading: Icon(Icons.directions_bus_sharp),
            title: CustomText(text: "Buss",),
          ),
          ListTile(
            onTap: (){changeScreen(context, ShowCompanies());},
            leading: Icon(Icons.article),
            title: CustomText(text: "Companies",),
          ),
          ListTile(
            onTap: (){authProvider.signOut();
            changeScreen(context, HomeScreen());
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "Sign out",),
          ),
        ],
      ),
    );
  }
}

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: ListView(
        children: [
      /*    ListTile(
            onTap: (){changeScreen(context, HomeScreen()); },
            leading: Icon(Icons.home),
            title: CustomText(text: "Home",),
          ),
          ListTile(
            onTap: (){changeScreen(context, LiveMapBroadcast());},
            leading: Icon(Icons.map),
            title: CustomText(text: "Near Buss",),
          ),
          ListTile(
            onTap: (){changeScreen(context, ShowBuss());},
            leading: Icon(Icons.directions_bus_sharp),
            title: CustomText(text: "Buss",),
          ),
          ListTile(
            onTap: (){changeScreen(context, ShowCompanies());},
            leading: Icon(Icons.article),
            title: CustomText(text: "Companies",),
          ),*/
          ListTile(
            onTap: (){
            changeScreen(context, LoginScreen());
            },
            leading: Icon(Icons.exit_to_app),
            title: CustomText(text: "Log In",),
          ),
        ],
      ),
    );
  }
}
