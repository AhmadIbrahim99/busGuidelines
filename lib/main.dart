import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stalker/admin/adminScreen.dart';
import 'package:stalker/driver/home.dart';
import 'package:stalker/helpers/commons.dart';
import 'package:stalker/providers/user.dart';
import 'package:stalker/shared_screen/home.dart';
import 'package:stalker/shared_screen/wellcome.dart';

import 'widgets/loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: UserProvider.initialize())],
    child: MaterialApp(

      debugShowCheckedModeBanner: false,
      title: "Bus Guide",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

//Start SplashScreen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ScreenController()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Image.asset(
              "images/buss.png",
              height: 120,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Powered By ©",
                style: TextStyle(color: white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//end SplashScreen

//Screen Controller

class ScreenController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return SelectAccount();
      case Status.Unauthenticated:
        return SelectAccount();
      case Status.Authenticating:
        return Loading();
      case Status.Authenticated:
        return HomeDriverScreen();
      case Status.AuthenticatedAdmin:
        return AdminScreen();
      default:
        return HomeScreen();
    }
  }
}



//end


/*localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', ''),
      ],
      locale: Locale('ar', ''),*/