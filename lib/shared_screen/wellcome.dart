import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stalker/helpers/screen_navigation.dart';
import 'package:stalker/shared_screen/home.dart';
import 'package:stalker/sign_screen/login.dart';

class SelectAccount extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/buss.png",width: 200,height: 200,),
            Container(
              width: 200,
              child: TextButton(
                autofocus: true,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white) ,
                  ),
                  onPressed: (){changeScreen(context, HomeScreen());}, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("User",style: TextStyle(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(width: 10.0,),
                      Icon(Icons.near_me),
                    ],
                  )),
            ),
            Container(
              width: 200,
              child: TextButton(
                  autofocus: true,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white) ,
                  ),
                  onPressed: (){changeScreen(context, LoginScreen());}, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Driver",style: TextStyle(color: Colors.blue,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(width: 10.0,),
                      Icon(Icons.vpn_key),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
