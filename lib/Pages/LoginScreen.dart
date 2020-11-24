//===packages====
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';

//===local_files=====
import 'package:flutter/material.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:ecommerce/db/functions.dart';
import 'package:ecommerce/components/constants.dart';
import 'package:ecommerce/components/Round_button.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/RegisterationScreen.dart';
import 'package:ecommerce/Pages/ForgotPassword.dart';
import 'package:ecommerce/provider/user_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool hide = true;
  bool getSpinner = false;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.dstATop))),
      child: user.status == Status.Authenticating? Loading() :Scaffold(
        key: _key,
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: getSpinner,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontFamily: 'Lobster',
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 48.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 0.0,
                          color: Colors.white.withOpacity(0.2),
                          child: TextFormField(
                            controller: user.email,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "please enter a value";
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Enter your email',
                                prefixIcon:
                                Icon(Icons.alternate_email, color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(10.0),
                          elevation: 0.0,
                          color: Colors.white.withOpacity(0.2),
                          child: TextFormField(
                            controller: user.password,
                            textAlign: TextAlign.center,
                            obscureText: hide,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "The password field cannot be empty";
                              }
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your password',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hide = !hide;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,right: 8,bottom: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        RoundButton(
                          Colors.white,
                          'LOGIN',
                          () async{
                            if (_formKey.currentState.validate()) {
                              if (!await user.signIn()) {
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Log in Failed",
                                  desc: "incorrect id/password",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "try again",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () =>
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen())),
                                      width: 120,
                                      color: Colors.black,
                                    )
                                  ],
                                ).show();
                              } else {
                                Fluttertoast.showToast(msg: "Logged in Successfully",backgroundColor: Colors.black,textColor: Colors.white,);
                                user.clearController();
                                changeScreenReplacement(
                                    context, HomeScreen());
                              }
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '-OR-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'sign in with',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap:
                                () async{
                                if (!await user.googleSignIn()) {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Log in Failed",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "try again",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () =>
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen())),
                                        width: 120,
                                        color: Colors.black,
                                      )
                                    ],
                                  ).show();
                                } else {
                                  Fluttertoast.showToast(msg: "Logged in Successfully",backgroundColor: Colors.black,textColor: Colors.white,);
                                  changeScreenReplacement(
                                      context, HomeScreen());
                                }
                          },
                          child: Center(
                            child: CircleAvatar(
                              radius: 35.0,
                              backgroundImage:
                                  AssetImage("images/google.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an Account?    ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    setState(() {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationScreen()));

                                      getSpinner = true;
                                    });
                                  },
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

