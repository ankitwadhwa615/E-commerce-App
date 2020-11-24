import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/db//users.dart';
import 'package:ecommerce/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  Firestore _firestore = Firestore.instance;
  UserServices _userService = UserServices();
  UserModel _userModel;
  FirebaseUser currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


//  we will make this variables public for now
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();


  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn()async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp()async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email.text, password: password.text).then((user){
        _userService.createUser(
            {
              "username": name.text,
              "email": email.text,
              'id':user.user.uid
            });
        _firestore.collection('user').document(user.user.uid).setData({
          'username':name.text,
          'email':email.text,
          'id':user.user.uid
        });
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future signOut()async{
     _auth.signOut();
     _googleSignIn.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController(){
    name.text = "";
    password.text = "";
    email.text = "";
  }


  Future<void> _onStateChanged(FirebaseUser user) async{
    if(user == null){
      _status = Status.Unauthenticated;
    }else{
      _user = user;
      _status = Status.Authenticated;
      _userModel = await _userService.getUserById(user.uid);
    }
    notifyListeners();
  }
//==========Google_Sign_IN==========================================================================

Future<bool> googleSignIn() async {
    try{
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleuser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleuser.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final FirebaseUser firebaseUser =
          (await _auth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection("user")
            .where('id', isEqualTo: firebaseUser.uid)
            .getDocuments();
        List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          _userService.createUser(
              {
                "id": firebaseUser.uid,
                "username": firebaseUser.displayName,
                "profilePicture": firebaseUser.photoUrl,
                "email": firebaseUser.email
              }
          );
          Firestore.instance
              .collection("user")
              .document(firebaseUser.uid)
              .setData({
            "id": firebaseUser.uid,
            "username": firebaseUser.displayName,
            "profilePicture": firebaseUser.photoUrl,
            "email": firebaseUser.email
          });
        }
        return true;
      }} catch(e) {
      print(e);
        _status = Status.Unauthenticated;
        notifyListeners();
        return false;
      }


  }
////==========Google_Sign_IN_end==========================================================================

}