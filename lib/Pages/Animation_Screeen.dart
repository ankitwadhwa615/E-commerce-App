import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import 'package:flutter/animation.dart';

class AnimationScreen extends StatefulWidget {
  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward();
   //isSignIn();
  }

  void isSignIn() async {
    setState(() {
      getSpinner = true;
    });
    isLoggedInWithGoogle = await _googleSignIn.isSignedIn();

    if (isLoggedInWithGoogle) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else if (isLoggedInWithFacebook) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    setState(() {
      getSpinner = false;
    });
  }

    bool getSpinner = false;
  bool isLoggedInWithGoogle = false;
  bool isLoggedInWithFacebook = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            backgroundColor: Colors.blue,
            body: Transform(
              transform:
              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
              child: Container(
                child: Center(
                    child: Text(
                      'E-commerce',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800),
                    )),
              ),
            ),
          );
        });
  }
}
//