import 'package:ecommerce/Pages/Cart.dart';
import 'package:ecommerce/components/CartIcon.dart';
import 'package:ecommerce/components/Products.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class PriceSortedScreen extends StatefulWidget {
  final filter;
  PriceSortedScreen(this.filter);
  @override
  _PriceSortedScreenState createState() => _PriceSortedScreenState();
}

class _PriceSortedScreenState extends State<PriceSortedScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              backgroundColor: Colors.black,
              title: Text(
                'Shoe Bazaar',
                style: TextStyle(
                    fontSize: 25, color: Colors.white, fontFamily: 'Lobster'),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.sort, color: Colors.white),
                    onPressed: () {
                      showAlertDialog(context);
                    }),
                CartIcon(),
              ],
            ),
            body: Products(widget.filter),
          );
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
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
