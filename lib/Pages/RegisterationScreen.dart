import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import 'package:ecommerce/components/constants.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:ecommerce/db/Users.dart';
import 'package:ecommerce/db/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/components/Round_button.dart';
//=====packages====
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool getSpinner = false;
  Map value;

  TextEditingController _confirmPasswordTextController =
      TextEditingController();

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
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: getSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Sign up',
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
                      controller:user.name,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please enter a value";
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter username',
                          prefixIcon: Icon(Icons.person, color: Colors.white)),
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
                      obscureText: hidePassword,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please enter a value";
                        } else if (value.length < 6) {
                          return 'password must be of atleast 6 characters';
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'set password',
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
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
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
                      controller: _confirmPasswordTextController,
                      textAlign: TextAlign.center,
                      obscureText: hideConfirmPassword,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "please enter a value";
                        } else if (user.password.text != value) {
                          return "the passwords doesn't match ";
                        }
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Confirm password',
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
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundButton(Colors.white, 'Sign Up', () async{
                    if (_formKey.currentState.validate()) {
                        if(!await user.signUp()){
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Sign-Up Failed",
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
                                                RegistrationScreen())),
                                width: 120,
                                color: Colors.black,
                              )
                            ],
                          ).show();
                        }
                        else{
                          Fluttertoast.showToast(msg: "Signed Up Successfully",backgroundColor: Colors.black,textColor: Colors.white,);
                        user.clearController();changeScreenReplacement(context, HomeScreen());
                        }
                      }
                  }),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
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
      ),
    );
  }
}
