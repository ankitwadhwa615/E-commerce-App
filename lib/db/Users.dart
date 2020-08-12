import'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user.dart';
class UserServices {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String user = "users";
  String collection = "users";
  Firestore _firestore = Firestore.instance;
  String ref= 'user';

  createUser(Map value) {
    _database.reference().child(user).push().set(
        value
    ).catchError((e) =>
    {
      print(e.toString())
    });
  }
  Future<List<DocumentSnapshot>> getUser() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });
//  void createUser(Map<String, dynamic> values){
//    _firestore.collection(collection).document(values["id"]).setData(values);
//  }
  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(collection).document(values["id"]).updateData(values);
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).document(id).get().then((doc){
        return UserModel.fromSnapshot(doc);
      });
}




//keytool -exportcert -alias androiddebugkey -keystore "C:\Users\ankitwadhwa\.android\debug.keystore" | "PATH_TO_OPENSSL_LIBRARY\bin\openssl" sha1 -binary | "PATH_TO_OPENSSL_LIBRARY\bin\openssl" base64


