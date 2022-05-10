import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  static const NAME = "name";
  static const EMAIL = "email";
  static const ID = "id";
  static const STRIPE_ID="stripe_Id";
  static const USER_LOCATION="user_location";
  static const UniversityOrSchool="university_or_school";
  static const AGE = "age";
  static const COLLEGE="college";
  static const DEPARTMENT = "department";
  static const INFORMATION = "information";


  String _name;
  String _email;
  String _id;
  String _stripeId;
  String _userLocation;
  String _university;
  int _age;
  String _college;
  String _department;
  String _information;

  //getters

  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get likedFood => _stripeId;
  String get userLocation => _userLocation;
  String get university => _university;
  int get age => _age;
  String get college => _college;
  String get department =>_department;
  String get information =>_information;

  UserModel.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _id = snapshot.data()[ID];
    _stripeId = snapshot.data()[STRIPE_ID];
    _userLocation = snapshot.data()[USER_LOCATION];
    _university = snapshot.data()[UniversityOrSchool];
    _age = snapshot.data()[AGE];
    _college = snapshot.data()[COLLEGE];
    _department = snapshot.data()[DEPARTMENT];
    _information = snapshot.data()[INFORMATION];
  }
}