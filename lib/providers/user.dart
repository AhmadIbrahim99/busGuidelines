import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stalker/helpers/user.dart';
import 'package:stalker/models/user.dart';

enum Status{Uninitialized, Unauthenticated, Authenticating, Authenticated, AuthenticatedAdmin, AuthenticatedDriver}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  User _user;
  Status _status=Status.Uninitialized;
  //FirebaseFirestore _firestore=FirebaseFirestore.instance;
  UserServices _userServices=UserServices();
  static UserModel _userModel;

  //getters
  Status get status => _status;
  static UserModel get userModel => _userModel;
  User get user => _user;

  final formKey=GlobalKey<FormState>();

  TextEditingController email=TextEditingController();
  TextEditingController userName=TextEditingController();
  TextEditingController password=TextEditingController();

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.authStateChanges().listen(_authStateChanged);
  }

  Future<bool> signIn() async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      return true;
    }catch(e){
      return _onError(e.toString());
    }
  }
  Future<bool> admin() async{
    try{
      if(email.text=="admin"&&password.text=="admin"){
        _status = Status.AuthenticatedAdmin;
        notifyListeners();
        return true;
      }else{
        return false;
      }
    }catch(e){
      return _onError(e.toString());
    }
  }

  Future<bool> driver() async{
    try{
      if(email.text=="driver"&&password.text=="driver"){
        _status = Status.AuthenticatedDriver;
        notifyListeners();
        return true;
      }else{
        return false;
      }
    }catch(e){
      return _onError(e.toString());
    }
  }

  Future<bool> signUp() async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email.text, password: password.text).then((value) {
        Map<String, dynamic>values= {
          "name": userName.text,
          "email": email.text,
          "id": value.user.uid,
          "likedBuss" : [],
          "likedCompanies" : [],
        };
        _userServices.createUser(values);
      });
      return true;
    }catch(e){
      return _onError(e.toString());
    }
  }

  Future signOut() {
    _auth.signOut();
    _status=Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _authStateChanged(User fireUser)async{
    if(fireUser == null){
      _status = Status.Uninitialized;
    }else{
      _user = fireUser;
      _status=Status.Authenticated;
      _userModel = await _userServices.getUserById(fireUser.uid);
    }
    notifyListeners();
  }

  //general Methods

  bool _onError(String error){
    _status=Status.Unauthenticated;
    notifyListeners();
    print("error: "+error);
    return false;
  }

  void cleanControllers(){
    email.text="";
    password.text="";
    userName.text="";
  }
}