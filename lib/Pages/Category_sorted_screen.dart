import 'package:ecommerce/Pages/Cart.dart';
import 'package:ecommerce/Pages/HomePage.dart';
import 'package:ecommerce/components/CartIcon.dart';
import 'package:ecommerce/components/Products.dart';
import 'package:flutter/material.dart';

class CategorySortedScreen extends StatefulWidget {
  final filter;
  CategorySortedScreen(this.filter);
  @override
  _CategorySortedScreenState createState() => _CategorySortedScreenState();
}

class _CategorySortedScreenState extends State<CategorySortedScreen> {
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
              actions: <Widget>[
                CartIcon()
              ],
            ),
            body: Products(widget.filter),
          );
  }
}
