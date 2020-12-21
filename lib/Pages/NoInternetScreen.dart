import 'dart:async';

import 'package:ecommerce/db/functions.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  Timer timer;
  @override
  void initState() {
     timer=Timer.periodic(Duration(seconds: 2),(Timer t)=>checkConnectivity());
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
   timer.cancel();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 220,),
          Image.asset('images/NoInternet.png'),
          SizedBox(height: 15,),
          Text('Ooops!',style: TextStyle(fontSize:50 ,fontWeight:FontWeight.bold,color: Colors.black38),),
          Text('No internet connection found\n     Check your connection',style: TextStyle(fontSize:20 ,color: Colors.black26),),
          SizedBox(height: 25,),
          FlatButton(onPressed: (){
            checkConnectivity();
          },color: Colors.black, child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Try Again',style: TextStyle(color: Colors.white),),
          ))
        ],
      ),
    );
  }
  checkConnectivity()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        timer.cancel();
        changeScreen(context,ScreensController());
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }
}
