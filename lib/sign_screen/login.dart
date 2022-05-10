import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stalker/admin/adminScreen.dart';
import 'package:stalker/driver/home.dart';
import '../helpers/commons.dart';
import '../helpers/screen_navigation.dart';
import '../providers/user.dart';
import '../widgets/custom_text.dart';
import '../widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassword=true;

  final _key=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      backgroundColor: white,
      body: authProvider.status == Status.Authenticating?
      Loading() :
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/buss.png",width: 240,height: 240,),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                    controller: authProvider.email,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                      icon: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                    controller: authProvider.password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                      hintText: "PassWord",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                      suffixIcon: isPassword ?IconButton(onPressed: (){
                        setState(() {
                          isPassword=!isPassword;
                        });
                      }, icon: Icon(Icons.visibility_off)):IconButton(onPressed: (){
                        setState(() {
                          isPassword=!isPassword;
                        });
                      }, icon: Icon(Icons.visibility)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: ()async{
                  if(await authProvider.admin()){
                    authProvider.cleanControllers();
                    changeScreen(context, AdminScreen());
                  }
                  if(await authProvider.driver()){
                    authProvider.cleanControllers();
                    changeScreen(context, HomeDriverScreen());
                  }
                  if(!await authProvider.signIn()){
                    _key.currentState.showSnackBar(
                      SnackBar(content: Text("Log In Failed")),
                    );
                    return ;
                  }
                  authProvider.cleanControllers();
                  changeScreenReplaceUntil(context, HomeDriverScreen());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: red,
                    border: Border.all(color: grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: "Login",color: white,size: 22,weight: FontWeight.bold,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           /* GestureDetector(
              onTap: (){changeScreen(context, RegistrationScreen());},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "Register here",size: 20,),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

