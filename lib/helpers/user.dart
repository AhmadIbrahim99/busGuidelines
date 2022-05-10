import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stalker/models/user.dart';

class UserServices{
  String collection = "users";
  FirebaseFirestore _firestore=FirebaseFirestore.instance;

  void createUser(Map<String, dynamic>values) =>  _firestore.collection(collection).doc(values["id"]).set(values);

  void updateUser(Map<String, dynamic>values)=> _firestore.collection(collection).doc(values["id"]).update(values);

  Future<UserModel> getUserById(String id) => _firestore.collection(collection).doc(id).get().
  then((value) {
    return UserModel.fromSnapshot(value);
  }
  );
}