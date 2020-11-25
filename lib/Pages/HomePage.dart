import 'package:ecommerce/Pages/Orders_Screen.dart';
import 'package:ecommerce/Pages/Price_Sorted_Screen.dart';
import 'package:ecommerce/components/Horizontal_List.dart';
import 'package:ecommerce/components/Products.dart';
import 'package:ecommerce/components/loading.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/Pages/Cart.dart';
import 'package:ecommerce/Pages/LoginScreen.dart';
import '../components/carousel.dart';
import '../components/CartIcon.dart';
//=====packages=====
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/db/functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';


FirebaseUser loggedInUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  List<DocumentSnapshot> users = <DocumentSnapshot>[];
  
  // bool search = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  bool isPhotoUrl() {
    if (loggedInUser.photoUrl != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isDisplayName() {
    if (loggedInUser.displayName != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    if (isLoading) {
      return Loading();
    } else {
      return Scaffold(
            appBar: AppBar(
                elevation: 0.1,
                backgroundColor: Colors.black,
                title: Text(
                  'Shoe Bazaar',
                  style: TextStyle(
                      fontSize: 25, color: Colors.white, fontFamily: 'Lobster'),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.sort, color: Colors.white),
                      onPressed: () {
                        showAlertDialog(context);
                      }),
                  CartIcon(),
                  //  IconButton(
                  //              icon: Icon(Icons.shopping_cart, color: Colors.white),
                  //              onPressed: () {
                  //                Navigator.push(
                  //                    context, MaterialPageRoute(builder: (context) => Cart()));
                  //              })
                ]),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: isDisplayName()
                        ? Text('${loggedInUser.displayName}')
                        : Text('Hey! User'),
                    accountEmail: Text('${loggedInUser.email}'),
                    currentAccountPicture: GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: isPhotoUrl()
                            ? NetworkImage('${loggedInUser.photoUrl}')
                            : AssetImage(
                                'images/profile.jpg',
                              ),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Text('Home Page'),
                      leading: Icon(
                        Icons.home,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersScreen()));
                    },
                    child: ListTile(
                      title: Text('My orders'),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart()));
                    },
                    child: ListTile(
                      title: Text('Shopping Cart'),
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('About'),
                      leading: Icon(
                        Icons.help,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Are you sure ",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Log Out",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              user.signOut();
                              changeScreenReplacement(context, LoginScreen());
                              Fluttertoast.showToast(
                                msg: "logged Out Successfully",
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                              );
                            },
                            width: 120,
                            color: Colors.black,
                          ),
                          DialogButton(
                              child: Text('cancel'),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              })
                        ],
                      ).show();
                    },
                    child: ListTile(
                      title: Text('Logout'),
                      leading: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 200,
                  child: CarouselImages(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                HorizontalList(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'All Products',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  child: Products(''),
                ),
              ],
            ),
          );
    }
  }

  showAlertDialog(BuildContext context) {
    Widget newArrivals = GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PriceSortedScreen("newArrivals")));
      },
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New Arrivals',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
    Widget highToLowButton = GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PriceSortedScreen("highToLow")));
      },
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Price:  high to low',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
    Widget lowToHighButton = GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PriceSortedScreen('lowToHigh')));
      },
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Price:  low to high',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sort by:-',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          SizedBox(height: 15),
          newArrivals,
          lowToHighButton,
          highToLowButton,
        ],
      )),
    );
    showDialog(
        // useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
// Widget SearchAppBar() {
//    return AppBar(
//      elevation: 0.1,
//      backgroundColor: Colors.black,
//      title: Container(
//        height: 35,
//        decoration: BoxDecoration(
//          color: Colors.white70,
//          borderRadius: BorderRadius.circular(32),
//        ),
//        child: TextField(
//
//          cursorColor: Colors.black,
//          autofocus: true,
//          decoration: InputDecoration(
//              contentPadding: EdgeInsets.only(top:2),
//              hintText: 'search',hintStyle: TextStyle(color: Colors.black45),
//              border: InputBorder.none,
//              errorBorder: InputBorder.none,
//              enabledBorder: InputBorder.none,
//              focusedBorder: InputBorder.none,
//              disabledBorder: InputBorder.none,
//              suffixIcon: IconButton(icon: Icon(Icons.search),onPressed: (){
//              },color: Colors.black,),
//              prefixIcon: IconButton(
//                icon: Icon(Icons.arrow_back,),color: Colors.black,iconSize: 20,
//                onPressed: (){setState(() {
//                  search=false;
//                });},)),
////
////                   onChanged:(val){
////            initiateSearch(val);
////          }
//        ),
//      ),
//      actions: <Widget>[
//        IconButton(
//            icon: Icon(Icons.shopping_cart, color: Colors.white),
//            onPressed: () {
//              Navigator.push(
//                  context, MaterialPageRoute(builder: (context) => Cart()));
//            })
//      ],
//
//    );
//IconButton(
//              icon: Icon(Icons.search, color: Colors.white), onPressed: () {
//            setState(() {
//              search = true;
//            });
//          }),
