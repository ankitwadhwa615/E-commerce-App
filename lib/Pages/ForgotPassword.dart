import 'package:flutter/material.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import 'package:ecommerce/components/constants.dart';
import 'package:ecommerce/components/Round_button.dart';
//=====packages====
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _formKey = GlobalKey<FormState>();
  bool getSpinner = false;
  TextEditingController _emailTextController = TextEditingController();

  void continueButton() async {
    setState(() {
      getSpinner = true;
    });
    await _auth.sendPasswordResetEmail(email: _emailTextController.text);
    setState(() {
      getSpinner = false;
    });
    Alert(
      context: context,
      type: AlertType.success,
      title: "email sent",
      desc:
          'An email has been sent to your registered email id for resetting password',
      buttons: [
        DialogButton(
          child: Text(
            "log in",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())),
          width: 120,
          color: Colors.black,
        )
      ],
    ).show();
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: getSpinner,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 0.0,
                  color: Colors.white.withOpacity(0.2),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please enter a value";
                        }
                      },
                      controller: _emailTextController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                          prefixIcon:
                              Icon(Icons.alternate_email, color: Colors.white)),
                    ),
                  ),
                ),
                RoundButton(Colors.white, 'Continue', () {
                  if(_formKey.currentState.validate()){
                    continueButton();
                  }
                }),
                Center(
                  child: InkWell(
                    onTap: (){Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen()));},
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
