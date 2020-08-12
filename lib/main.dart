import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/components/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize())
  ] ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScreensController(),
      )));
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