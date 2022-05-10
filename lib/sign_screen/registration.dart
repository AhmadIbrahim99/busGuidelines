import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stalker/admin/adminScreen.dart';
import 'package:stalker/helpers/commons.dart';
import 'package:stalker/helpers/screen_navigation.dart';
import 'package:stalker/providers/user.dart';
import 'package:stalker/widgets/custom_text.dart';
import 'package:stalker/widgets/loading.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

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
                    controller: authProvider.userName,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: InputBorder.none,
                      icon: Icon(Icons.person),
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
                  if(!await authProvider.signUp()){
                    _key.currentState.showSnackBar(
                      SnackBar(content: Text("Registration Failed")),
                    );
                    return ;
                  }
                  authProvider.cleanControllers();
                  changeScreen(context, AdminScreen());
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
                        CustomText(text: "Register",color: white,size: 22,weight: FontWeight.bold,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           /* GestureDetector(
              onTap: (){changeScreen(context, LoginScreen());},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "Login here",size: 20,),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
