import 'dart:async';

import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:animated_splash/animated_splash.dart';
import 'dart:io';

import 'Pages/NoInternetScreen.dart';
import 'db/functions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider.initialize())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashClass(),
      )));
}

class SplashClass extends StatefulWidget {
  @override
  _SplashClassState createState() => _SplashClassState();
}

class _SplashClassState extends State<SplashClass> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplash(
      type: AnimatedSplashType.StaticDuration,
      duration: 1500,
      imagePath: 'images/splash.png',
      home: CheckConnectivity(),
    );
  }
}

class ScreensController extends StatefulWidget {
  @override
  _ScreensControllerState createState() => _ScreensControllerState();
}

class _ScreensControllerState extends State<ScreensController> {
  Timer timer;
  @override
  void initState() {
    timer=Timer.periodic(Duration(seconds: 2),(Timer t)=>checkConnectivity());
    super.initState();
  }
  checkConnectivity()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      timer.cancel();
      changeScreen(context,NoInternetScreen());
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return HomeScreen();
      default:
        return LoginScreen();
    }
  }
}


class CheckConnectivity extends StatefulWidget {
  @override
  _CheckConnectivityState createState() => _CheckConnectivityState();
}
class _CheckConnectivityState extends State<CheckConnectivity> {
  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }
  void checkConnectivity()async{
    try {
      setState(() {
        loading=true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          loading=false;
          connected=true;
        });
      }
      else{
        setState(() {
          loading=false;
          connected=false;
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        loading=false;
        connected=false;
      });
    }
  }
  bool connected=false;
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading?Loading():connected?ScreensController():NoInternetScreen();
  }
}
