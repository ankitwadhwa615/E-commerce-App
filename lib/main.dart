import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:animated_splash/animated_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize())
  ] ,
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
    return  AnimatedSplash(
      type: AnimatedSplashType.StaticDuration,
      duration: 1500,
      imagePath: 'images/1.jpg',
      home: ScreensController(),
    );
  }
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch(user.status){
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return HomeScreen();
      default: return LoginScreen();
    }
  }
}